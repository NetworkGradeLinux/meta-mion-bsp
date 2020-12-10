# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

KMACHINE_accton-asgvolt64 ?= "common-pc-64"
KMACHINE_accton-wedge100bf-32x ?= "common-pc-64"
KMACHINE_accton-wedge100bf-65x ?= "common-pc-64"

KBRANCH_accton-asgvolt64  ?= "v5.4/standard/base"
KBRANCH_accton-wedge100bf-32x  ?= "v5.4/standard/base"
KBRANCH_accton-wedge100bf-65x  ?= "v5.4/standard/base"

LINUX_VERSION_accton-asgvolt64 ?= "5.4.49"
LINUX_VERSION_accton-wedge100bf-32x ?= "5.4.49"
LINUX_VERSION_accton-wedge100bf-65x ?= "5.4.49"

SRC_URI_append_accton-asgvolt64 += "file://defconfig \
            file://veth.cfg \
            file://crypto.cfg \
"
SRC_URI_append_accton-wedge100bf-32x += "file://defconfig \
            file://veth.cfg \
            file://crypto.cfg \
"
SRC_URI_append_accton-wedge100bf-65x += "file://defconfig \
            file://veth.cfg \
            file://crypto.cfg \
"

SRC_URI_append = "\
        ${@bb.utils.contains('DISTRO_FEATURES', 'powersave', ' file://power.cfg', '', d)}"

SRCREV_machine_asgvolt64 ?= "ec485bd4afef57715eb45ba331b04b3f941e43bb"
SRCREV_machine_wedge100bf-32x ?= "ec485bd4afef57715eb45ba331b04b3f941e43bb"
SRCREV_machine_wedge100bf-65x ?= "ec485bd4afef57715eb45ba331b04b3f941e43bb"

# Functionality flags
KERNEL_EXTRA_FEATURES_accton-asgvolt64 ?= "features/netfilter/netfilter.scc features/security/security.scc"
KERNEL_EXTRA_FEATURES_accton-wedge100bf-32x ?= "features/netfilter/netfilter.scc features/security/security.scc"
KERNEL_EXTRA_FEATURES_accton-wedge100bf-65x ?= "features/netfilter/netfilter.scc features/security/security.scc"

COMPATIBLE_MACHINE = "(accton-asgvolt64|accton-wedge100bf-32x|accton-wedge100bf-65x)" 
