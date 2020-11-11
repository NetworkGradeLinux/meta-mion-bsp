# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend_bf2556x := "${THISDIR}/${MACHINE}:"
ONL_BRANCH_bf2556x = "main"
URI_ONL_bf2556x = "git://git@github.com/APS-Networks/OpenNetworkLinuxv2.git;protocol=ssh;branch=${ONL_BRANCH}"
MODULE_bf2556x="x86_64_stordis_bf2556x_1t"
EXTRA_OEMAKE += "\
    'ARCH=amd64'\
    'UCLIHANDLERS2=${S}/sm/bigcode/tools/uclihandlers2.py'\
    'SUBMODULE_INFRA=${S}/sm/infra'\
"

COMPATIBLE_MACHINE = "stordis-bf2556x-1t"

SRC_URI_append_bf2556x = " \
    file://0001-Add-i2c-smbus.h-to-vendor_driver_pool.c.patch \
"

