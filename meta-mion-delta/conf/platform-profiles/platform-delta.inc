ONIE_VENDOR = "delta"
ONIE_MACHINE_TYPE = "${@d.getVar('MACHINE').replace('delta-','')}"

# TODO setup a mapping?
ONIE_VENDOR_SHORT ?= "${ONIE_VENDOR}"
ONIE_ARCH = "arm64"
ONL_MACHINE ?= "${@d.getVar('MACHINE').replace('delta-','')}"
ONIE_MACHINE ?= "${@d.getVar('ONL_MACHINE').replace('-','_')}"
ONIE_MACHINE_REV ?= "0"
ONIE_PLATFORM ?= "${ONIE_ARCH}-${ONIE_MACHINE}-r${ONIE_MACHINE_REV}"
ONL_VENDOR = "${ONIE_VENDOR}"
ONL_ARCH = "${@d.getVar('ONIE_ARCH').replace('_','-')}"

# onl vars
ONL_DEBIAN_SUITE = "mion"
