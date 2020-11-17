

# Mion porting guild 
The following document outlines the steps necessary to create a Yocto board support package (BSP)

**NOTE: This process and the files outlined below are subject to change as the format of meta-mion-bsp is codified**

The following platform-specific strings are required for file names and config settings in the BSP:
- ONL_VENDOR (ONIE_VENDOR) - OEM vendor name as per ONL, using "-" to separate words (the same but with "\_" used as word separator)
  - e.g. accton, stordis, etc. 
- ONL_MACHINE (ONIE_MACHINE) - OEM machine name as per ONL, using "-" to separate words (the same but with "\_" used as word separator)
  - e.g. as4610-30, bf2556c-1t, etc.
- ONL_ARCH (ONIE_ARCH) - OEM machine arch as per ONL, using "-" as a word separator  (the same but with "\_" used as as word separator)
  - e.g. x86-64 (x86_64), armel, armhf, etc.

## Create the board support package (BSP) directories and files
- Check if meta-mion-bsp/meta-mion-<ONL_VENDOR>/ exists and create if necessary 
  - e.g. meta-mion-bsp/meta-mion-accton/
- Create platform config in meta-mion-bsp/meta-mion-<ONL_VENDOR>/conf/ based on the existing BSPs. You will need:
  - conf/layer.conf - similar to existing layer.conf files used for other BSPSvim 
  - conf/machine/<ONL_MACHINE>.conf - This is a typical Yocto Project machine config. See the Yocto Project documentation on it’s format [link](https://www.yoctoproject.org/docs/current/bsp-guide/bsp-guide.html)
  - conf/platform-profiles/platform-<OLN_VENDOR>.conf - based on the other platform profiles
  - Create meta-mion-bsp/meta-mion-<ONL_VENDOR>/conf/onie-profiles/<ONL_VENDOR>-<ONL_MACHINE>/
  - Populate onlpv{1,2}/{machine,platform}.conf
    - machine.conf: contains PLATFORM="<ONIE_ARCH>-<ONIE_VENDOR>_<ONIE_MACHINE>"
    - platform.conf: contains platform specific ONIE installer variables and functions usually found in the ONIE repo
  - Create meta-mion-<ONL_VENDOR>/recipes-platform/ (if it doesnt exist) and populate the following as neededL
    - onlpv1/<ONL_VENDOR>-<ONL_MACHINE>/ and onlpv1/onplv1_%.bbappend - containing the ONLP specific patches

## Modify the kernel config and add defconfig files
- Create a directory called meta-mion-bsp/meta-mion-<ONL_VENDOR>/recipes-kernel/linux/<MACHINE>/
- Create a "defconfig" in the above dir - it might be possible to generate this file using ONL or base it on a similar system already in meta-mion-bsp
- Add any required config fragments (*.cfg)
- Modify meta-mion-bsp/meta-mion-<ONL_VENDOR>/recipes-kernel/linux/linux-yocto_<VER>.bbappend and add the following variables
  - KMACHINE_<MACHINE>
  - KBRANCH_<MACHINE>
  - SRC_URI_append_<MACHINE>
  - SRCREV_machine_<MACHINE>
  - KERNEL_EXTRA_FEATURES_<MACHINE>
  - and add <MACHINE> to COMPATIBLE_MACHINE
 
## Platform recipes
Like the linux kernel recipe above, machine specific variables may be required. Due to the nature of various platform implementations within ONL, machine specific overrides will probably be required, specifically EXTRA_OEMAKE_append to set the needed ARCH, do_install (either to overwrite it or append/prepend). You most likely will also need to patch the Makefile within the platform’s onlp/builds directory to set FILTER from src to <ONIE_VENDOR>_<ONIE_ARCH>_<ONIE_MACHINE>.

This part of the port is very vendor and platform specific and tends to require the most effort.
