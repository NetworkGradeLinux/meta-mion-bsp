# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

KMACHINE_delta-tn48m ?= "aarch64"
KBRANCH_delta-tn48m  ?= "v5.10/standard/base"

SRC_URI_append += "file://0005-fsl-ls1043a-rdb-sdk.patch \
          file://0006-fsl-ls1046a-rdb-sdk.patch \
          file://0007-qoriq-dpaa-eth.patch \
          file://0008-qorig-fman3-0-6oh.patch \
          file://0009-delta-tx4810-dts.patch \
          file://0010-wnc-qsd61-aom-a-48.patch \
          file://0011-wnc-qsa72-aom-a-48p.patch \
          file://0012-accton-as4224.patch \
          file://0013-delta-tn48m-series.patch \
          file://0014-prestera-switchdev-driver.patch \
          file://0015-Add-port-ranges-structures.patch \
          file://0016-nvmem-core-allow-to-register-cells-for-existing-device.patch \
          file://0017-nvmem-add-ONIE-NVMEM-cells-support.patch \
          file://0018-userspace-stp.patch \
          file://0020-accton-as5114.patch \
          file://0021-tn48m-add-sfp-eeprom-support-to-ethtool.patch \
          file://0022-delta-tn48m-dn-series-dts.patch \
          file://defconfig \
          file://veth.cfg \
          file://crypto.cfg \
"

INITRAMFS_IMAGE = "mion-onie-image-dent-initramfs"

SRC_URI_append = "\
        ${@bb.utils.contains('DISTRO_FEATURES', 'powersave', ' file://power.cfg', '', d)}"

# Functionality flags
KERNEL_EXTRA_FEATURES_delta-tn48m?= "features/netfilter/netfilter.scc features/security/security.scc"

COMPATIBLE_MACHINE = "delta-tn48m"

# fitImage kernel compression algorithm
FIT_KERNEL_COMP_ALG ?= "none"
FIT_KERNEL_COMP_ALG_EXTENSION ?= ""

uboot_prep_kimage() {
	if [ -e arch/${ARCH}/boot/compressed/vmlinux ]; then
		vmlinux_path="arch/${ARCH}/boot/compressed/vmlinux"
		linux_suffix=""
		linux_comp="none"
	elif [ -e arch/${ARCH}/boot/vmlinuz.bin ]; then
		rm -f linux.bin
		cp -l arch/${ARCH}/boot/vmlinuz.bin linux.bin
		vmlinux_path=""
		linux_suffix=""
		linux_comp="none"
	else
		vmlinux_path="vmlinux"
		linux_suffix="${FIT_KERNEL_COMP_ALG_EXTENSION}"
		linux_comp="${FIT_KERNEL_COMP_ALG}"
	fi

	[ -n "${vmlinux_path}" ] && ${OBJCOPY} -O binary -R .note -R .comment -S "${vmlinux_path}" linux.bin

	if [ "${linux_comp}" != "none" ] ; then
		gzip -9 linux.bin
		mv -f "linux.bin${linux_suffix}" linux.bin
	fi

	echo "${linux_comp}"
}
 
