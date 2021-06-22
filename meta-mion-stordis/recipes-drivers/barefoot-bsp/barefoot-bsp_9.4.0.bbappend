FILESEXTRAPATHS_prepend := "${THISDIR}/${MACHINE}:"

BSP_PLATFORM_CODE_stordis-bf2556x-1t = "bf-reference-bsp-9.4.0-BF2556_1.0.2"
BSP_PLATFORM_CODE_stordis-bf6064x-t = "bf-reference-bsp-9.4.0-BF6064_1.0.1"

SRC_URI_stordis-bf2556x-1t = "file://0001-Remove-host-includes.patch;patchdir=${WORKDIR}/git/bf-platforms-${SDE_VERSION}"
SRC_URI_stordis-bf6064x-t = "file://0001-Remove-host-includes.patch;patchdir=${WORKDIR}/git/bf-platforms-${SDE_VERSION}"


EXTRA_OECONF_stordis-bf2556x-1t += "--prefix=${STAGING_DIR} --with-tof-brgup-plat --with-libtool-sysroot=${STAGING_DIR}"
EXTRA_OECONF_stordis-bf6064x-t += "--prefix=${STAGING_DIR} --with-libtool-sysroot=${STAGING_DIR}"
COMPATIBLE_MACHINE = "(stordis-bf2556x-1t|stordis-bf6064x-t)"

