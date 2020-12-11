
#include <linux/init.h>
#include <linux/module.h>
#include <linux/interrupt.h>
#include <linux/debugfs.h>
#include <linux/signal_types.h>
#include <asm/siginfo.h>

#include <linux/sched.h>

#include <linux/version.h>

#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,0,0)
#include <linux/sched/signal.h> // added
#endif

#include <linux/uaccess.h>

MODULE_LICENSE("Dual BSD/GPL"); 

static int irq_num = 19;
MODULE_PARM_DESC(irq_num,  "debug which irq number");
module_param(irq_num, int, 0644);
struct dentry *irq_file;
static struct task_struct *user_task = NULL;
static struct kernel_siginfo info;

static void *irq_dev_id = (void *)&irq_num;
static struct tasklet_struct tasklet; 

void irq_debug_tasklet(unsigned long data)
{
	int ret = 0;
	
	//printk("%s called (%ld, %ld, %ld)\n", __func__, in_irq(), in_softirq(), in_interrupt());

	/* send the signal */
	if(user_task)
	{
		ret = send_sig_info(SIGUSR1, &info, user_task);	   //send the signal
		if(ret < 0)
		{
			pr_err("irq_debug error sending signal\n");
		}
	}
	
} 

static ssize_t write_pid(struct file *file, const char __user *buf,
								size_t count, loff_t *ppos)
{
	char tmp_buf[10];
	int pid = 0;
	int ret;
	
	/* read the value from user space */
	if(count > sizeof(tmp_buf))
	{
		return -EINVAL;
	}
	copy_from_user(tmp_buf, buf, count);
	sscanf(tmp_buf, "%d", &pid);
	//pr_info("pid = %d\n", pid);
 
	/* prepare the signal */
	memset(&info, 0x0, sizeof(struct kernel_siginfo));
	info.si_signo = SIGUSR1;
	/*
	this is bit of a trickery: SI_QUEUE is normally used by sigqueue from user space,
	and kernel space should use SI_KERNEL. But if SI_KERNEL is used the real_time data 
	is not delivered to the user space signal handler function. 
	*/
	info.si_code = SI_QUEUE;
	/* real time signals may have 32 bits of data. */
	info.si_int = 1234;
 
	rcu_read_lock();
	/* find the task with that pid */
	user_task = pid_task(find_pid_ns(pid, &init_pid_ns), PIDTYPE_PID);	
	if(user_task == NULL)
	{
		pr_err("irq_debug no such pid\n");
		rcu_read_unlock();
		return -ENODEV;
	}
	rcu_read_unlock();
 
	/* send the signal */
	ret = send_sig_info(SIGUSR1, &info, user_task);	   //send the signal
	if(ret < 0)
	{
		pr_err("irq_debug error sending signal\n");
		return ret;
	}
 
	return count;
}

irqreturn_t irq_debug_isr(int irq, void *dev_instance)
{ 
	if(printk_ratelimit())
	{ 
		//printk(KERN_INFO "irq_debug %s: irq %d (%ld, %ld, %ld)\n", __func__, irq, in_irq(), in_softirq(), in_interrupt()); 
	}
	
	tasklet_schedule(&tasklet);
	
	return IRQ_NONE; 
} 

static const struct file_operations irq_fops =
{
	.write = write_pid,
};

static int irq_debug_init(void)
{ 
	int ret = 0;
	char buf[32];
	
	printk(KERN_ALERT "irq_debug driver installed.\n"); 

	tasklet_init(&tasklet, irq_debug_tasklet, 0); 
	ret = request_irq(irq_num, irq_debug_isr, IRQF_SHARED, "irq_debug", irq_dev_id); 

	if (ret)
	{ 
		printk("request_irq() failed (%d)\n", ret); 
		return (ret); 
	} 

	memset(buf, 0x0, sizeof(buf));
	sprintf(buf, "reg_pid_for_irq%d", irq_num);
	irq_file = debugfs_create_file(buf, 0200, NULL, NULL, &irq_fops);
	
	return 0; 
} 

static void irq_debug_exit(void)
{ 
	printk(KERN_ALERT "irq_debug driver removed\n"); 
	tasklet_kill(&tasklet); 
	free_irq(irq_num, irq_dev_id);
	debugfs_remove(irq_file);
} 

module_init(irq_debug_init); 
module_exit(irq_debug_exit); 

