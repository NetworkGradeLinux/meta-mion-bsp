# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

SRC_URI_append = " \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"

TARGET_CFLAGS_delta-tn48m += "-Wno-error -Wno-error=restrict -Wno-error=format-overflow -Wno-error=cpp -Wno-error=unused-result"

MODULE_delta-tn48m="arm64-delta-tn48m"

COMPATIBLE_MACHINE="(delta-tn48m)"

