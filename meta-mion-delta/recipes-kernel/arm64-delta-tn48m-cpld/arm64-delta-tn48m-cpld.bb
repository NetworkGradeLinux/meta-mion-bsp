SUMMARY = "This module supports arm64-delta-tn48m-cpld"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e"

inherit module

SRC_URI = " \
    file://Makefile \
    file://arm64-delta-tn48m-cpld.c \
    file://COPYING \
    "

S = "${WORKDIR}"


do_install() {
    install -d ${D}/lib/modules/${KERNEL_VERSION}/onl
    install -m 0644 arm64-delta-tn48m-cpld.ko ${D}/lib/modules/${KERNEL_VERSION}/onl
}

KERNEL_MODULE_AUTOLOAD += " arm64-delta-tn48m-cpld"
