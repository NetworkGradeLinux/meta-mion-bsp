# SPDX-License-Identifier: MIT 

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRCREV = "${AUTOREV}"
SRCREV_onl = "${AUTOREV}"
#SRCREV= "d558b77a8d7a9725e1e198d8cce94604c514981c"
#SRCREV_onl = "d558b77a8d7a9725e1e198d8cce94604c514981c"
SRCREV_infra = "16ce9cd77f6639aac4813d698f9dd11f3ee47e7a"
SRCREV_bigcode = "94091600faa76fac492b4be2ffab17cb9788d697"
ONIE_VENDOR = "stordis"
ONIE_VENDOR_SHORT = "stordis"
#ONIE_MACHINE_TYPE
ONL_VENDOR = "stordis"
ONIE_ARCH = "x86-64"
ONIE_MACHINE = "bf2556x-1t"
ONL_BRANCH = "eflanagan/wip"
URI_ONL = "git://git@github.com/APS-Networks/OpenNetworkLinux.git;protocol=ssh;branch=${ONL_BRANCH}"
SRC_URI += " \
    file://0001-i2c-bigcode-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_BIGCODE} \
    file://0001-i2c-infra-use-libi2c-for-onlpdump-and-update-headers.patch;patchdir=${SUBMODULE_INFRA} \
    file://0001-i2c-use-libi2c-for-onlpdump-and-update-headers.patch \
"
MODULE="x86_64_stordis_bf2556x_1t"
DEPENDS += "libedit libzip"
EXTRA_OEMAKE+="\
    'ARCH=amd64'\
"
do_compile() {
  # examples
  #oe_runmake -C packages/base/any/onlp/builds/ show_targets show_libs show_bins show_shared show_scripts
  #oe_runmake -C packages/base/any/onlp/builds/ alltargets

  V=1 VERBOSE=1 oe_runmake -C packages/base/any/onlp/builds alltargets
  V=1 VERBOSE=1 oe_runmake -C packages/base/any/onlp/builds/onlpd alltargets

  V=1 VERBOSE=1 oe_runmake -C packages/platforms/${ONIE_VENDOR}/${ONL_ARCH}/${ONIE_MACHINE}/onlp/builds alltargets
}

do_install() {
  # folders in dest
  install -d \
    ${D}${bindir} \
    ${D}${includedir}/AIM \
    ${D}${includedir}/BigList \
    ${D}${includedir}/IOF \
    ${D}${includedir}/cjson \
    ${D}${includedir}/onlp \
    ${D}${includedir}/onlplib \
    ${D}${libdir}

  # install onlpdump
  install -m 0755 packages/platforms/${ONIE_VENDOR}/${ONL_ARCH}/${ONIE_MACHINE}/onlp/builds/onlpdump/BUILD/${ONL_DEBIAN_SUITE}/${TOOLCHAIN}/bin/onlps ${D}${bindir}

  # install headers
  install -m 0644 packages/base/any/onlp/src/onlp/module/inc/onlp/*.h ${D}${includedir}/onlp/
  install -m 0644 packages/base/any/onlp/src/onlplib/module/inc/onlplib/*.h ${D}${includedir}/onlplib/
  install -m 0644 sm/bigcode/modules/BigData/BigList/module/inc/BigList/*.h ${D}${includedir}/BigList/
  install -m 0644 sm/bigcode/modules/IOF/module/inc/IOF/*.h ${D}${includedir}/IOF/
  install -m 0644 sm/bigcode/modules/cjson/module/inc/cjson/*.h ${D}${includedir}/cjson/
  install -m 0644 sm/infra/modules/AIM/module/inc/AIM/*.h ${D}${includedir}/AIM/

  # install libonlp-platform shared library (includes AIM.a  AIM_posix.a  BigList.a  cjson.a  cjson_util.a  IOF.a  onlplib.a  x86_64_delta_ag7648.a)
  # /home/pidge/mion/build/tmp/work/genericx86_64-oe-linux/onlpv1/1.1+gitAUTOINC+bf94be3c2a_16ce9cd77f_94091600fa-r0/git/packages/platforms/stordis/x86-64/x86-64-bf2556x-1t/onlp/builds/onlpdump/BUILD/yocto/
  #
  install -m 0755 packages/platforms/${ONIE_VENDOR}/${ONL_ARCH}/${ONIE_MACHINE}/onlp/builds/lib/BUILD/${ONL_DEBIAN_SUITE}/${TOOLCHAIN}/bin/libonlp-${ONIE_ARCH}-${ONL_VENDOR}-${ONIE_MACHINE}.so ${D}${libdir}
  mv ${D}${libdir}/libonlp-${ONIE_ARCH}-${ONL_VENDOR}-${ONIE_MACHINE}.so ${D}${libdir}/libonlp-${ONIE_ARCH}-${ONL_VENDOR}-${ONIE_MACHINE}.so.1
  ln -r -s ${D}${libdir}/libonlp-${ONIE_ARCH}-${ONL_VENDOR}-${ONIE_MACHINE}.so.1 ${D}${libdir}/libonlp-${ONIE_ARCH}-${ONL_VENDOR}-${ONIE_MACHINE}.so
  ln -r -s ${D}${libdir}/libonlp-${ONIE_ARCH}-${ONL_VENDOR}-${ONIE_MACHINE}.so.1 ${D}${libdir}/libonlp-platform.so.1

  # install libonlp shared library (includes TODO)
  install -m 0755 packages/base/any/onlp/builds/onlp/BUILD/${ONL_DEBIAN_SUITE}/${TOOLCHAIN}/bin/libonlp.so ${D}${libdir}
  mv ${D}${libdir}/libonlp.so ${D}${libdir}/libonlp.so.1
  ln -r -s ${D}${libdir}/libonlp.so.1 ${D}${libdir}/libonlp.so

  # install libonlp shared library (includes TODO)
  install -m 0755 packages/base/any/onlp/builds/onlp-platform-defaults/BUILD/${ONL_DEBIAN_SUITE}/${TOOLCHAIN}/bin/libonlp-platform-defaults.so ${D}${libdir}
  mv ${D}${libdir}/libonlp-platform-defaults.so ${D}${libdir}/libonlp-platform-defaults.so.1
  ln -r -s ${D}${libdir}/libonlp-platform-defaults.so.1 ${D}${libdir}/libonlp-platform-defaults.so

  # platform file
  install -d ${D}${sysconfdir}/onl
  echo "${ONIE_ARCH}-${ONIE_VENDOR}-${ONIE_MACHINE}-r${ONIE_MACHINE_REV}" > ${D}${sysconfdir}/onl/platform

  # service file
  install -d ${D}${systemd_unitdir}/system
  install -m 0644 ${WORKDIR}/onlpdump.service ${D}${systemd_unitdir}/system
  sed -i -e 's,@BINDIR@,${bindir},g' \
         ${D}${systemd_unitdir}/system/*.service

  # install platform.xml file
  install -d ${D}/lib/platform-config/current/onl/
  install -m 0664 packages/platforms/${ONIE_VENDOR}/${ONL_ARCH}/${ONIE_MACHINE}/platform-config/r0/src/lib/platform.xml ${D}/lib/platform-config/current/onl/platform.xml
}

FILES_${PN} += "/lib/platform-config/*"

