# SPDX-License-Identifier: MIT 

SUMMARY = ""
LICENSE = "MIT"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

SRC_URI += " \
    file://platform-accton-init.service \
    file://platform-accton-init.sh \
"

FILES_${PN} = " \
    ${systemd_system_unitdir}/platform-accton-init.service \
    ${bindir}/platform-accton-init.sh \
"


do_install() {
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/platform-accton-init.service ${D}${systemd_system_unitdir}
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/platform-accton-init.sh ${D}${bindir}
}

SYSTEMD_SERVICE_${PN}_append = "platform-accton-init.service"
