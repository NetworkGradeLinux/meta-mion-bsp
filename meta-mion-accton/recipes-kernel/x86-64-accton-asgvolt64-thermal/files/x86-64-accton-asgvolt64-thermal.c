/*
 * Copyright (C)  Brandon Chuang <brandon_chuang@accton.com.tw>
 *
 * Based on:
 *	pca954x.c from Kumar Gala <galak@kernel.crashing.org>
 * Copyright (C) 2006
 *
 * Based on:
 *	pca954x.c from Ken Harrenstien
 * Copyright (C) 2004 Google, Inc. (Ken Harrenstien)
 *
 * Based on:
 *	i2c-virtual_cb.c from Brian Kuschak <bkuschak@yahoo.com>
 * and
 *	pca9540.c from Jean Delvare <khali@linux-fr.org>.
 *
 * This file is licensed under the terms of the GNU General Public
 * License version 2. This program is licensed "as is" without any
 * warranty of any kind, whether express or implied.
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/device.h>
#include <linux/version.h>
#include <linux/stat.h>
#include <linux/sysfs.h>
#include <linux/hwmon-sysfs.h>
#include <linux/ipmi.h>
#include <linux/ipmi_smi.h>
#include <linux/platform_device.h>

#define DRVNAME "asgvolt64_thermal"
#define ACCTON_IPMI_NETFN       0x34
#define IPMI_THERMAL_READ_CMD   0x12
#define IPMI_TIMEOUT		(20 * HZ)

static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data);
static ssize_t show_temp(struct device *dev, struct device_attribute *attr, char *buf);
static int asgvolt64_thermal_probe(struct platform_device *pdev);
static int asgvolt64_thermal_remove(struct platform_device *pdev);

enum temp_data_index {
    TEMP_ADDR,
    TEMP_FAULT,
    TEMP_INPUT,
    TEMP_DATA_COUNT
};

struct ipmi_data {
	struct completion   read_complete;
	struct ipmi_addr	address;
	struct ipmi_user  * user;
	int                 interface;

	struct kernel_ipmi_msg tx_message;
	long                   tx_msgid;

	void            *rx_msg_data;
	unsigned short   rx_msg_len;
	unsigned char    rx_result;
	int              rx_recv_type;

	struct ipmi_user_hndl ipmi_hndlrs;
};

struct asgvolt64_thermal_data {
    struct platform_device *pdev;
    struct mutex     update_lock;
    char             valid;           /* != 0 if registers are valid */
    unsigned long    last_updated;    /* In jiffies */
    char   ipmi_resp[22]; /* 3 bytes for each thermal. 7-thermal, so need 7*3=21 */
    struct ipmi_data ipmi;
};

struct asgvolt64_thermal_data *data = NULL;

static struct platform_driver asgvolt64_thermal_driver = {
    .probe      = asgvolt64_thermal_probe,
    .remove     = asgvolt64_thermal_remove,
    .driver     = {
        .name   = DRVNAME,
        .owner  = THIS_MODULE,
    },
};

enum asgvolt64_thermal_sysfs_attrs {
	TEMP1_INPUT,
    TEMP2_INPUT,
    TEMP3_INPUT,
    TEMP4_INPUT,
    TEMP5_INPUT,
    TEMP6_INPUT,
    TEMP7_INPUT,
};

static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, TEMP1_INPUT);
static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_temp, NULL, TEMP2_INPUT);
static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, show_temp, NULL, TEMP3_INPUT);
static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, show_temp, NULL, TEMP4_INPUT);
static SENSOR_DEVICE_ATTR(temp5_input, S_IRUGO, show_temp, NULL, TEMP5_INPUT);
static SENSOR_DEVICE_ATTR(temp6_input, S_IRUGO, show_temp, NULL, TEMP6_INPUT);
static SENSOR_DEVICE_ATTR(temp7_input, S_IRUGO, show_temp, NULL, TEMP7_INPUT);

static struct attribute *asgvolt64_thermal_attributes[] = {
    &sensor_dev_attr_temp1_input.dev_attr.attr,
    &sensor_dev_attr_temp2_input.dev_attr.attr,
    &sensor_dev_attr_temp3_input.dev_attr.attr,
    &sensor_dev_attr_temp4_input.dev_attr.attr,
    &sensor_dev_attr_temp5_input.dev_attr.attr,
    &sensor_dev_attr_temp6_input.dev_attr.attr,
    &sensor_dev_attr_temp7_input.dev_attr.attr,
    NULL
};

static const struct attribute_group asgvolt64_thermal_group = {
    .attrs = asgvolt64_thermal_attributes,
};

/* Functions to talk to the IPMI layer */

/* Initialize IPMI address, message buffers and user data */
static int init_ipmi_data(struct ipmi_data *ipmi, int iface,
			      struct device *dev)
{
	int err;

	init_completion(&ipmi->read_complete);

	/* Initialize IPMI address */
	ipmi->address.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
	ipmi->address.channel = IPMI_BMC_CHANNEL;
	ipmi->address.data[0] = 0;
	ipmi->interface = iface;

	/* Initialize message buffers */
	ipmi->tx_msgid = 0;
	ipmi->tx_message.netfn = ACCTON_IPMI_NETFN;

    ipmi->ipmi_hndlrs.ipmi_recv_hndl = ipmi_msg_handler;

	/* Create IPMI messaging interface user */
	err = ipmi_create_user(ipmi->interface, &ipmi->ipmi_hndlrs,
			       ipmi, &ipmi->user);
	if (err < 0) {
		dev_err(dev, "Unable to register user with IPMI "
			"interface %d\n", ipmi->interface);
		return -EACCES;
	}

	return 0;
}

/* Send an IPMI command */
static int ipmi_send_message(struct ipmi_data *ipmi, unsigned char cmd,
                                     unsigned char *tx_data, unsigned short tx_len,
                                     unsigned char *rx_data, unsigned short rx_len)
{
	int err;

    ipmi->tx_message.cmd      = cmd;
    ipmi->tx_message.data     = tx_data;
    ipmi->tx_message.data_len = tx_len;
    ipmi->rx_msg_data         = rx_data;
    ipmi->rx_msg_len          = rx_len;

	err = ipmi_validate_addr(&ipmi->address, sizeof(ipmi->address));
	if (err)
		goto addr_err;

	ipmi->tx_msgid++;
	err = ipmi_request_settime(ipmi->user, &ipmi->address, ipmi->tx_msgid,
				   &ipmi->tx_message, ipmi, 0, 0, 0);
	if (err)
		goto ipmi_req_err;

    err = wait_for_completion_timeout(&ipmi->read_complete, IPMI_TIMEOUT);
	if (!err)
		goto ipmi_timeout_err;

	return 0;

ipmi_timeout_err:
    err = -ETIMEDOUT;
    dev_err(&data->pdev->dev, "request_timeout=%x\n", err);
    return err;
ipmi_req_err:
	dev_err(&data->pdev->dev, "request_settime=%x\n", err);
	return err;
addr_err:
	dev_err(&data->pdev->dev, "validate_addr=%x\n", err);
	return err;
}

/* Dispatch IPMI messages to callers */
static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
{
	unsigned short rx_len;
	struct ipmi_data *ipmi = user_msg_data;

	if (msg->msgid != ipmi->tx_msgid) {
		dev_err(&data->pdev->dev, "Mismatch between received msgid "
			"(%02x) and transmitted msgid (%02x)!\n",
			(int)msg->msgid,
			(int)ipmi->tx_msgid);
		ipmi_free_recv_msg(msg);
		return;
	}

	ipmi->rx_recv_type = msg->recv_type;
	if (msg->msg.data_len > 0)
		ipmi->rx_result = msg->msg.data[0];
	else
		ipmi->rx_result = IPMI_UNKNOWN_ERR_COMPLETION_CODE;

	if (msg->msg.data_len > 1) {
		rx_len = msg->msg.data_len - 1;
		if (ipmi->rx_msg_len < rx_len)
			rx_len = ipmi->rx_msg_len;
		ipmi->rx_msg_len = rx_len;
		memcpy(ipmi->rx_msg_data, msg->msg.data + 1, ipmi->rx_msg_len);
	} else
		ipmi->rx_msg_len = 0;

	ipmi_free_recv_msg(msg);
	complete(&ipmi->read_complete);
}

static ssize_t show_temp(struct device *dev, struct device_attribute *da, char *buf)
{
    int status = 0;
    int index  = 0;
    struct sensor_device_attribute *attr = to_sensor_dev_attr(da);

    mutex_lock(&data->update_lock);

    if (time_after(jiffies, data->last_updated + HZ * 5) || !data->valid) {
        data->valid = 0;

        status = ipmi_send_message(&data->ipmi, IPMI_THERMAL_READ_CMD, NULL, 0,
                                    data->ipmi_resp, sizeof(data->ipmi_resp));
        if (unlikely(status != 0)) {
            goto exit;
        }

        if (unlikely(data->ipmi.rx_result != 0)) {
            status = -EIO;
            goto exit;
        }

        data->last_updated = jiffies;
        data->valid = 1;
    }

    /* Get temp fault status */
    index = attr->index * TEMP_DATA_COUNT + TEMP_FAULT;
    if (unlikely(data->ipmi_resp[index] == 0)) {
        status = -EIO;
        goto exit;
    }

    /* Get temperature in degree celsius */
    index = attr->index * TEMP_DATA_COUNT + TEMP_INPUT;
    status = data->ipmi_resp[index] * 1000;

    mutex_unlock(&data->update_lock);
    return sprintf(buf, "%d\n", status);

exit:
    mutex_unlock(&data->update_lock);
    return status;
}

static int asgvolt64_thermal_probe(struct platform_device *pdev)
{
    int status = -1;

	/* Register sysfs hooks */
	status = sysfs_create_group(&pdev->dev.kobj, &asgvolt64_thermal_group);
	if (status) {
		goto exit;
	}
    
    dev_info(&pdev->dev, "device created\n");

    return 0;

exit:
    return status;
}

static int asgvolt64_thermal_remove(struct platform_device *pdev)
{
    sysfs_remove_group(&pdev->dev.kobj, &asgvolt64_thermal_group);	

    return 0;
}

static int __init asgvolt64_thermal_init(void)
{
    int ret;

    data = kzalloc(sizeof(struct asgvolt64_thermal_data), GFP_KERNEL);
    if (!data) {
        ret = -ENOMEM;
        goto alloc_err;
    }

	mutex_init(&data->update_lock);
    data->valid = 0;

    ret = platform_driver_register(&asgvolt64_thermal_driver);
    if (ret < 0) {
        goto dri_reg_err;
    }

    data->pdev = platform_device_register_simple(DRVNAME, -1, NULL, 0);
    if (IS_ERR(data->pdev)) {
        ret = PTR_ERR(data->pdev);
        goto dev_reg_err;
    }

	/* Set up IPMI interface */
	ret = init_ipmi_data(&data->ipmi, 0, &data->pdev->dev);
	if (ret)
		goto ipmi_err;

    return 0;

ipmi_err:
    platform_device_unregister(data->pdev);
dev_reg_err:
    platform_driver_unregister(&asgvolt64_thermal_driver);
dri_reg_err:
    kfree(data);
alloc_err:
    return ret;
}

static void __exit asgvolt64_thermal_exit(void)
{
    ipmi_destroy_user(data->ipmi.user);
    platform_device_unregister(data->pdev);
    platform_driver_unregister(&asgvolt64_thermal_driver);
    kfree(data);
}

MODULE_AUTHOR("Brandon Chuang <brandon_chuang@accton.com.tw>");
MODULE_DESCRIPTION("ASGVOLT64 Thermal driver");
MODULE_LICENSE("GPL");

module_init(asgvolt64_thermal_init);
module_exit(asgvolt64_thermal_exit);

