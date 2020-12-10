# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend_asgvolt64 := "${THISDIR}/${MACHINE}:"
FILESEXTRAPATHS_prepend_wedge100bf-32x := "${THISDIR}/${MACHINE}:"
FILESEXTRAPATHS_prepend_wedge100bf-65x := "${THISDIR}/${MACHINE}:"

SRCREV_asgvolt64 = "${AUTOREV}"
SRCREV_wedge100bf-32x = "${AUTOREV}"
SRCREV_wedge100bf-65x = "${AUTOREV}"

SRCREV_onl_asgvolt64 = "${AUTOREV}"
SRCREV_onl_wedge100bf-32x = "${AUTOREV}"
SRCREV_onl_wedge100bf-65x = "${AUTOREV}"

SRCREV_infra_asgvolt64 = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_infra_wedge100bf-32x = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_infra_wedge100bf-65x = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"

SRCREV_bigcode_asgvolt64 = "94091600faa76fac492b4be2ffab17cb9788d697"
SRCREV_bigcode_wedge100bf-32x = "94091600faa76fac492b4be2ffab17cb9788d697"
SRCREV_bigcode_wedge100bf-65x = "94091600faa76fac492b4be2ffab17cb9788d697"

ONL_BRANCH_asgvolt64 = "master"
ONL_BRANCH_wedge100bf-32x = "master"
ONL_BRANCH_wedge100bf-65x = "master"

TARGET_CFLAGS_wedge100bf-32x += "-Wno-error -Wno-error=restrict -Wno-error=format-overflow -Wno-error=cpp -Wno-error=unused-result"
TARGET_CFLAGS_wedge100bf-65x += "-Wno-error -Wno-error=restrict -Wno-error=format-overflow -Wno-error=cpp -Wno-error=unused-result"

SRC_URI_append_asgvolt64 = " \
    file://filter.patch \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"
SRC_URI_append_wedge100bf-32x = " \
    file://filter.patch \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"
SRC_URI_append_wedge100bf-65x = " \
    file://filter.patch \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"

MODULE_asgvolt64 = "x86_64_accton_asgvolt64"
MODULE_wedge100bf-32x = "x86_64_accton_wedge100bf-32x"
MODULE_wedge100bf-65x = "x86_64_accton_wedge100bf-32x"

EXTRA_OEMAKE_append_asgvolt64 = "\
    'ARCH=amd64'\
"
EXTRA_OEMAKE_append_wedge100bf-32x = "\
    'ARCH=amd64'\
"
EXTRA_OEMAKE_append_wedge100bf-65x = "\
    'ARCH=amd64'\
"

COMPATIBLE_MACHINE = "(accton-asgvolt64|accton-wedge100bf-32x|accton-wedge100bf-65x)"
