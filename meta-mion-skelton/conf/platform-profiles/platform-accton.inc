ONIE_VENDOR = "skeleton"
ONIE_MACHINE_TYPE = "${@d.getVar('MACHINE').replace('skeleton-','')}"

# TODO setup a mapping?
ONIE_VENDOR_SHORT ?= "${ONIE_VENDOR}"
ONIE_ARCH = "${TARGET_ARCH}"
ONIE_MACHINE ?= "${@d.getVar('MACHINE').replace('skeleton-','')}"
ONIE_MACHINE_REV ?= "0"
ONIE_PLATFORM ?= "${ONIE_ARCH}-${ONIE_MACHINE}-r${ONIE_MACHINE_REV}"
ONL_VENDOR = "${ONIE_VENDOR}"
ONL_ARCH = "${@d.getVar('TARGET_ARCH').replace('_','-')}"
ONL_MACHINE = "${ONIE_MACHINE}"

# onl vars
ONL_DEBIAN_SUITE = "mion"
