# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRCREV_bf2556x = "${AUTOREV}"
SRCREV_bf6064x = "${AUTOREV}"
SRCREV_onl_bf2556x = "${AUTOREV}"
SRCREV_onl_bf6064x = "${AUTOREV}"
SRCREV_infra_bf2556x = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_infra_bf6064x = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_bigcode_bf2556x = "94091600faa76fac492b4be2ffab17cb9788d697"
SRCREV_bigcode_bf6064x = "94091600faa76fac492b4be2ffab17cb9788d697"

ONL_BRANCH_bf2556x = "main"
ONL_BRANCH_bf6064x = "main"

URI_ONL_bf2556x = "git://git@github.com/APS-Networks/OpenNetworkLinux.git;protocol=ssh;branch=${ONL_BRANCH}"
URI_ONL_bf6064x = "git://git@github.com/APS-Networks/OpenNetworkLinux.git;protocol=ssh;branch=${ONL_BRANCH}"

TARGET_CFLAGS_bf6064x += "-Wno-error -Wno-error=restrict -Wno-error=format-overflow -Wno-error=cpp"

SRC_URI_append = " \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"

SRC_URI_append_bf6064x = " \
    file://0001-Makefile-Add-FILTER-from-src-to-machine-name.patch \
"


MODULE_bf2556x = "x86_64_stordis_bf2556x_1t"
MODULE_bf6064x = "x86_64_stordis_bf6064x_t"

EXTRA_OEMAKE_append = "\
    'ARCH=amd64'\
"

COMPATIBLE_MACHINE="(stordis-bf2556x-1t|stordis-bf6064x-t)"

do_install_append_bf2556x() {
  # install platform.xml file
  install -d ${D}/lib/platform-config/${ONL_ARCH}-${ONL_VENDOR}-${ONL_MACHINE}-r${ONIE_MACHINE_REV}/onl/
  install -m 0664 packages/platforms/${ONIE_VENDOR}/${ONL_ARCH}/${ONL_MACHINE}/platform-config/r0/src/lib/platform.xml ${D}/lib/platform-config/${ONL_ARCH}-${ONL_VENDOR}-${ONL_MACHINE}-r${ONIE_MACHINE_REV}/onl/platform.xml
}
