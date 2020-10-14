# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
ONIE_VENDOR = "stordis"
ONIE_VENDOR_SHORT = "stordis"
ONL_VENDOR = "stordis"
ONIE_ARCH = "x86-64"
ONIE_MACHINE = "bf2556x-1t"
ONL_BRANCH = "main"
URI_ONL = "git://git@github.com/APS-Networks/OpenNetworkLinuxv2.git;protocol=ssh;branch=${ONL_BRANCH}"
MODULE="x86_64_stordis_bf2556x_1t"
EXTRA_OEMAKE+="\
    'ARCH=amd64'\
    'UCLIHANDLERS2=${S}/sm/bigcode/tools/uclihandlers2.py'\
    'SUBMODULE_INFRA=${S}/sm/infra'\
"

SRC_URI += " \
    file://0001-Add-i2c-smbus.h-to-vendor_driver_pool.c.patch \
"
