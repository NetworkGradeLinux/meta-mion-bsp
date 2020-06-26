FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRCREV_onl ?= "${AUTOREV}"
SRCREV_infra ?= "${AUTOREV}"
SRCREV_bigcode ?= "${AUTOREV}"

SRC_URI+=" \
    file://0001-Stordis-platform.patch \
    file://libdpapi.a;subdir=packages/platforms/stordis/x86-64/dpapi \
    file://onlpv1_for_bf2556x_1t_patch_20190620.diff \
    file://onl.patch \
"
