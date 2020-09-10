FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
KMACHINE_stordis-bf2556x-1t = "common-pc-64"
KBRANCH_stordis-bf2556x-1t  = "v5.4/standard/base"
LINUX_VERSION_stordis-bf2556x-1t = "5.4.49"

SRC_URI += " \
           file://veth.cfg \
           file://crypto.cfg \
          "

SRCREV_machine_stordis-bf2556x-1t ?= "ec485bd4afef57715eb45ba331b04b3f941e43bb"

# Functionality flags
KERNEL_EXTRA_FEATURES ?= "features/netfilter/netfilter.scc features/security/security.scc"

COMPATIBLE_MACHINE_stordis-bf2556x-1t = "stordis-bf2556x-1t"
