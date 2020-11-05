# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"
KMACHINE_accton-asgvolt64 ?= "common-pc-64"
KBRANCH_accton-asgvolt64  ?= "v5.4/standard/base"
LINUX_VERSION_accton-asgvolt64 ?= "5.4.49"

SRC_URI_append_accton-asgvolt64 += "file://defconfig \
            file://veth.cfg \
            file://crypto.cfg \
"

SRC_URI_append = "\
        ${@bb.utils.contains('DISTRO_FEATURES', 'powersave', ' file://power.cfg', '', d)}"

SRCREV_machine_asgvolt64 ?= "ec485bd4afef57715eb45ba331b04b3f941e43bb"

# Functionality flags
KERNEL_EXTRA_FEATURES_accton-asgvolt64 ?= "features/netfilter/netfilter.scc features/security/security.scc"

COMPATIBLE_MACHINE = "accton-asgvolt64"
 
