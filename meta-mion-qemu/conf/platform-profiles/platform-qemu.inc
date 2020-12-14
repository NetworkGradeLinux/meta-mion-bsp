ONIE_VENDOR = "qemu"
ONIE_MACHINE_TYPE = "${@d.getVar('MACHINE')}"

# TODO setup a mapping?
ONIE_VENDOR_SHORT ?= "${ONIE_VENDOR}"
ONIE_ARCH = "${TARGET_ARCH}"
ONL_MACHINE ?= "${@d.getVar('MACHINE')}"
ONIE_MACHINE ?= "${@d.getVar('MACHINE').replace('-','_')}"
ONIE_MACHINE_REV ?= "0"
ONIE_PLATFORM ?= "${ONIE_MACHINE}-r${ONIE_MACHINE_REV}"
ONL_VENDOR = "${ONIE_VENDOR}"
ONL_ARCH = "${@d.getVar('TARGET_ARCH').replace('_','-')}"

# onl vars
ONL_DEBIAN_SUITE = "mion"
