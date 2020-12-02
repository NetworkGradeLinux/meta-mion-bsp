# SPDX-License-Identifier: MIT 

SUMMARY = ""
LICENSE = "MIT"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

SRC_URI += " \
    file://platform-skeleton-init.service \
    file://platform-skeleton-init.sh \
"

FILES_${PN} = " \
    ${systemd_system_unitdir}/platform-skeleton-init.service \
    ${bindir}/platform-skeleton-init.sh \
"


do_install() {
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/platform-skeleton-init.service ${D}${systemd_system_unitdir}
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/platform-skeleton-init.sh ${D}${bindir}
}

SYSTEMD_SERVICE_${PN}_append = "platform-skeleton-init.service"
