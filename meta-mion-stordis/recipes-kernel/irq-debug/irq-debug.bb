SUMMARY = "This module supports irq_debug"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e"

inherit module

SRC_URI = " \
    file://Makefile \
    file://irq_debug.c \
	file://COPYING \
    "

S = "${WORKDIR}"

#TARGET_CFLAGS += " -Wno-incompatible-pointer-types -Wno-unused-result"

do_install() {
    install -d ${D}/lib/modules/${KERNEL_VERSION}/onl
    install -m 0644 irq_debug.ko ${D}/lib/modules/${KERNEL_VERSION}/onl
}

#KERNEL_MODULE_AUTOLOAD += " irq_debug"
