# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"
KMACHINE_skeleton-skelmachine ?= "common-pc-64"
KBRANCH_skeleton-skelmachine  ?= "v5.4/standard/base"
LINUX_VERSION_skeleton-skelmachine ?= "5.4.49"

SRC_URI_append_skeleton-skelmachine += "file://defconfig \
            file://veth.cfg \
            file://crypto.cfg \
"

SRC_URI_append = "\
        ${@bb.utils.contains('DISTRO_FEATURES', 'powersave', ' file://power.cfg', '', d)}"

SRCREV_machine_skelmachine ?= "ec485bd4afef57715eb45ba331b04b3f941e43bb"

# Functionality flags
KERNEL_EXTRA_FEATURES_skeleton-skelmachine ?= "features/netfilter/netfilter.scc features/security/security.scc"

COMPATIBLE_MACHINE = "skeleton-skelmachine"
 
