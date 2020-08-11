require recipes-kernel/linux/linux-yocto.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-yocto:"

LINUX_VERSION ?= "5.4.50"

PV = "${LINUX_VERSION}+git${SRCPV}"

KMETA = "kernel-meta"
KCONF_BSP_AUDIT_LEVEL = "2"

KBRANCH = "5.4/yocto"
KMETA_BRANCH = "yocto-5.4"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

KERNEL_CONFIG_URI ?= "git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${KMETA_BRANCH};destsuffix=${KMETA}"

SRC_URI = " \
           git://github.com/intel/linux-intel-lts.git;protocol=https;name=machine;branch=${KBRANCH}; \
           ${KERNEL_CONFIG_URI} \
          "

SRCREV_machine ?= "89e6c056f3076641486519375f7bf280bf833223"
SRCREV_meta ?= "b8c82ba37370e4698ff0c42f3e54b8b4f2fb4ac0"

# Functionality flags
KERNEL_EXTRA_FEATURES ?= "features/netfilter/netfilter.scc features/security/security.scc"

COMPATIBLE_MACHINE += "|stordis-bf2556x-1t"
