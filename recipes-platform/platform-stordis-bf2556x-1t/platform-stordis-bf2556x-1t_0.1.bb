# SPDX-License-Identifier: MIT 

SUMMARY = ""
LICENSE = "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

SRC_URI += " \
    file://platform-stordis-bf2556x-1t-init.service \
    file://platform-stordis-bf2556x-1t-init.sh \
"

FILES_${PN} = " \
    ${systemd_system_unitdir}/platform-stordis-bf2556x-1t-init.service \
    ${bindir}/platform-stordis-bf2556x-1t-init.sh \
"


do_install() {
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/platform-stordis-bf2556x-1t-init.service ${D}${systemd_system_unitdir}
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/platform-stordis-bf2556x-1t-init.sh ${D}${bindir}
}

SYSTEMD_SERVICE_${PN}_append = "platform-stordis-bf2556x-1t-init.service"
