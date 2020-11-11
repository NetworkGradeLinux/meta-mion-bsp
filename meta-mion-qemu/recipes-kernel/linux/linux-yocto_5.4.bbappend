# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"
KMACHINE_qemu-arm-qemu-armv7a ?= "qemuarma15"
KBRANCH_qemu-arm-qemu-armv7a  ?= "v5.4/standard/arm-versatile-926ejs"
LINUX_VERSION_qemu-arm-qemu-armv7a ?= "5.4.49"

SRC_URI_append_qemu-arm-qemu-armv7a += "file://defconfig \
            file://veth.cfg \
            file://crypto.cfg \
"

SRC_URI_append = "\
        ${@bb.utils.contains('DISTRO_FEATURES', 'powersave', ' file://power.cfg', '', d)}"

SRCREV_machine_qemuarm ?= "ec485bd4afef57715eb45ba331b04b3f941e43bb"

# Functionality flags
KERNEL_EXTRA_FEATURES_qemu-arm-qemu-armv7a ?= "features/netfilter/netfilter.scc features/security/security.scc"

COMPATIBLE_MACHINE = "qemu-arm-qemu-armv7a"
 
