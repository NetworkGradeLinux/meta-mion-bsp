# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend_bf2556x := "${THISDIR}/${MACHINE}:"
SRCREV_bf2556x = "${AUTOREV}"
SRCREV_onl_bf2556x = "${AUTOREV}"
SRCREV_infra_bf2556x = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_bigcode_bf2556x = "94091600faa76fac492b4be2ffab17cb9788d697"
ONL_BRANCH_bf2556x = "main"
URI_ONL_bf2556x = "git://git@github.com/APS-Networks/OpenNetworkLinux.git;protocol=ssh;branch=${ONL_BRANCH}"
SRC_URI_append_bf2556x = " \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"
MODULE_bf2556x = "x86_64_stordis_bf2556x_1t"
EXTRA_OEMAKE_append_bf2556x = "\
    'ARCH=amd64'\
"

COMPATIBLE_MACHINE="stordis-bf2556x-1t"

do_install_append_bf2556x() {
  # install platform.xml file
  install -d ${D}/lib/platform-config/current/onl/
  install -m 0664 packages/platforms/${ONIE_VENDOR}/${ONL_ARCH}/${ONIE_MACHINE}/platform-config/r0/src/lib/platform.xml ${D}/lib/platform-config/current/onl/platform.xml
}
