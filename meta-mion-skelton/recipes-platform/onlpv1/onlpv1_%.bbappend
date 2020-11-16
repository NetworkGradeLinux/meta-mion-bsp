# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend_skelmachine := "${THISDIR}/${MACHINE}:"
SRCREV_skelmachine = "${AUTOREV}"
SRCREV_onl_skelmachine = "${AUTOREV}"
SRCREV_infra_skelmachine = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_bigcode_skelmachine = "94091600faa76fac492b4be2ffab17cb9788d697"
ONL_BRANCH_skelmachine = "master"
SRC_URI_append_skelmachine = " \
    file://filter.patch \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"
MODULE_skelmachine = "x86_64_skeleton_skelmachine"
EXTRA_OEMAKE_append_skelmachine = "\
    'ARCH=amd64'\
"
COMPATIBLE_MACHINE = "skeleton-skelmachine"

