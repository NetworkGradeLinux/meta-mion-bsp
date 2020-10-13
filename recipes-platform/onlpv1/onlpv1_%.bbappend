# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRCREV = "${AUTOREV}"
SRCREV_onl = "${AUTOREV}"
SRCREV_infra = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_bigcode = "94091600faa76fac492b4be2ffab17cb9788d697"
ONIE_VENDOR = "stordis"
ONIE_VENDOR_SHORT = "stordis"
ONL_VENDOR = "stordis"
ONIE_ARCH = "x86-64"
ONIE_MACHINE = "bf2556x-1t"
ONL_BRANCH = "eflanagan/build-fixes"
URI_ONL = "git://git@github.com/APS-Networks/OpenNetworkLinux.git;protocol=ssh;branch=${ONL_BRANCH}"
SRC_URI += " \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"
MODULE="x86_64_stordis_bf2556x_1t"
EXTRA_OEMAKE+="\
    'ARCH=amd64'\
"
