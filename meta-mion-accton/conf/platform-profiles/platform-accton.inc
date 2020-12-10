ONIE_VENDOR = "accton"
ONIE_MACHINE_TYPE = "${@d.getVar('MACHINE').replace('accton-','')}"

# TODO setup a mapping?
ONL_MACHINE ?= "${@d.getVar('MACHINE').replace('accton-','')}"
ONL_VENDOR = "${ONIE_VENDOR}"
ONL_ARCH = "${@d.getVar('TARGET_ARCH').replace('_','-')}"
ONIE_MACHINE ?= "${@d.getVar('ONL_MACHINE').replace('-','_')}"
ONIE_VENDOR_SHORT ?= "${ONIE_VENDOR}"
ONIE_ARCH = "${TARGET_ARCH}"
ONIE_MACHINE_REV ?= "0"
ONIE_PLATFORM ?= "${ONIE_ARCH}-${ONIE_MACHINE}-r${ONIE_MACHINE_REV}"

# onl vars
ONL_DEBIAN_SUITE = "mion"
