SUMMARY = "This module supports cpld that read and write"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e"

inherit module

SRC_URI = " \
	  file://Makefile \
          file://x86-64-accton-asgvolt64-fan.c \
	  file://COPYING \
          "

S = "${WORKDIR}"

do_install() {
    install -d ${D}/lib/modules/${KERNEL_VERSION}/onl
    install -m 0644 x86-64-accton-asgvolt64-fan.ko ${D}/lib/modules/${KERNEL_VERSION}/onl
}


#KERNEL_MODULE_AUTOLOAD += " x86-64-accton-asgvolt64-fan"
