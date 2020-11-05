# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"
KMACHINE_stordis-bf2556x-1t ?= "common-pc-64"
KBRANCH_stordis-bf2556x-1t  ?= "v5.4/standard/base"
LINUX_VERSION_stordis-bf2556x-1t ?= "5.4.49"

SRC_URI_append_stordis-bf2556x-1t += "file://defconfig \
            file://veth.cfg \
            file://crypto.cfg \
"

SRC_URI_append = "\
        ${@bb.utils.contains('DISTRO_FEATURES', 'powersave', ' file://power.cfg', '', d)}"

SRCREV_machine_bf2556x ?= "ec485bd4afef57715eb45ba331b04b3f941e43bb"

# Functionality flags
KERNEL_EXTRA_FEATURES_stordis-bf2556x-1t ?= "features/netfilter/netfilter.scc features/security/security.scc"

COMPATIBLE_MACHINE = "stordis-bf2556x-1t"
 
