# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRCREV_qemux86-64 = "${AUTOREV}"
SRCREV_onl_qemux86-64 = "${AUTOREV}"
SRCREV_infra_qemux86-64 = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_bigcode_qemux86-64 = "94091600faa76fac492b4be2ffab17cb9788d697"

ONL_BRANCH_qemux86-64 = "main"

#URI_ONL_qemux86-64 = "git://github.com/opencomputeproject/OpenNetworkLinux.git;branch=${ONL_BRANCH}"


SRC_URI_append_qemux86-64 = " \
    file://0001-Change-qemu-platform-from-arm-to-x86-64.patch \
    file://0001-modtool.py-Fix-bad-os.walk.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
    file://filter.patch \
"
MODULE_qemux86-64 = "x86_64_qemu_qemux86_64"

# These don't really belong here, we need to find out why these aren't set in
# platform-qemu.inc
ONIE_VENDOR = "qemu"
ONL_VENDOR = "qemu"
#ONIE_VENDOR_SHORT ?= "qemu"
ONIE_MACHINE = "qemux86_64"
ONL_MACHINE ?= "qemux86-64"
#ONIE_PLATFORM ?= "x86_64-qemux86_64-r0"
ONL_ARCH = "x86-64"
ONIE_ARCH = "x86_64"

EXTRA_OEMAKE_append = "\
    'ARCH=amd64'\
"

COMPATIBLE_MACHINE="qemux86-64"
