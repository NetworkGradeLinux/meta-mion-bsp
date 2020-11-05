# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend_asgvolt64 := "${THISDIR}/${MACHINE}:"
SRCREV_asgvolt64 = "${AUTOREV}"
SRCREV_onl_asgvolt64 = "${AUTOREV}"
SRCREV_infra_asgvolt64 = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_bigcode_asgvolt64 = "94091600faa76fac492b4be2ffab17cb9788d697"
ONL_BRANCH_asgvolt64 = "master"
SRC_URI_append_asgvolt64 = " \
    file://filter.patch \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"
MODULE_asgvolt64 = "x86_64_accton_asgvolt64"
EXTRA_OEMAKE_append_asgvolt64 = "\
    'ARCH=amd64'\
"
COMPATIBLE_MACHINE = "accton-asgvolt64"
