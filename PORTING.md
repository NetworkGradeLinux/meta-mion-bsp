# mion Porting Guide

This guide covers *required* steps for creating a new Yocto Project Board
Support package (BSP) for mion; It is possible that further steps may need to be
taken to support your board, such as platform specific variables.

> **NOTE: This process and the files outlined below are subject to change as the
format of meta-mion-bsp is codified**

## Table of Contents

[Resources](#resources)

[Environment Variables](#environment-variables)

[Directories and Files](#Creating-the-bsp-package-directories-and-files)

[Kernel Configuration](#kernel-configuration)

[Platform Recipes](#platform-recipes)

## Resources

Below are links that you may find helpful. The Yocto Project BSP guide in
particular is recommended prerequisite reading, and a helpful reference source.
Github repository links for Open Network Linux (ONL) and the Open Network
Install Environment (ONIE) may be useful references, especially for platform
recipes.

* [Yocto Project Documentation BSP Guide](https://docs.yoctoproject.org/bsp-guide/bsp-guide.html#)
* [ONL github repository](https://github.com/opencomputeproject/OpenNetworkLinux)
* [ONIE github repository](https://github.com/opencomputeproject/onie)

## Environment Variables

The platform-specific variables below are required for file names and config
settings in the BSP, where the strings are the Original Equipment Manufacturer
(OEM) names as defined by ONL\*.

> \* **NOTE: Whereas ONL strings have words generally delineated with an
underscore("\_"), for the BSP layer you write, words are separated using a dash
("-") Examples of this can be seen throughout this guide**

* `ONL_VENDOR` (`ONIE_VENDOR`): Vendor name, e.g. accton, stordis.
* `ONL_MACHINE` (`ONIE_MACHINE`): Machine name, e.g. as4610-30, bf2556c-1t.
* `ONL_ARCH` (`ONIE_ARCH`):  Machine arch, e.g. x86-64 (x86_64), armel, armhf.

## Creating the BSP Package directories and files

First, you should check to see if `meta-mion-bsp/meta-mion-<ONL_VENDOR>/`
already exists. If it doesn't, then you'll need to create the directory. For
example, if you want to port an accton switch, and the folder doesn't exist,

```shell
mkdir `meta-mion-bsp/meta-mion-accton/`
```

You can also copy an existing one recursively, and precede with editing the
existing files:

```shell
cd meta-mion-bsp
cp -r meta-mion-stordis/  meta-mion-accton/
cd meta-mion-accton/
```

Next, create platform config directory:
`meta-mion-bsp/meta-mion-<ONL_VENDOR>/conf/`, and populate it with the files
and directories based on the existing BSPs:

* `conf/layer.conf` -- This is similar to existing [layer.conf](https://docs.yoctoproject.org/bsp-guide/bsp.html#layer-configuration-file)
files used for other BSPs. As the name suggests, this file provides information
about your bsp layer.

* `conf/machine/<ONL_VENDER>-<ONL_MACHINE>.conf` -- This is a typical Yocto
Project machine config. See the Yocto Project BSP Guide section,
[Hardware Configuration Options](https://www.yoctoproject.org/docs/current/bsp-guide/bsp-guide.html)
for more information. A good working example is the one for
the APS Networks (formerly STORDIS) BF2556X-1T platform: [stordis-bf2556x-1t.conf](https://github.com/NetworkGradeLinux/meta-mion-bsp/blob/dunfell/meta-mion-stordis/conf/machine/stordis-bf2556x-1t.conf)

* `conf/platform-profiles/platform-<ONL_VENDOR>.inc` -- base this on the other
platform profiles. This contains various platform variables. Example:
[platform-accton.inc](https://github.com/NetworkGradeLinux/meta-mion-bsp/blob/dunfell-next/meta-mion-accton/conf/platform-profiles/platform-accton.inc)

Create directory `meta-mion-<ONL_VENDOR>/conf/onie-profiles/<ONL_VENDOR>-<ONL_MACHINE>/`
and populate `onlpv{1,2}/{machine,platform}.conf`:

```shell
.
├── onlpv1
│   ├── machine.conf
│   └── platform.conf
├── onlpv2
│   ├── machine.conf
│   └── platform.conf

```

* `machine.conf` -- contains a single line:`PLATFORM="<ONIE_ARCH>-<ONIE_VENDOR>_<ONIE_MACHINE>"`.
Note that `ONIE_VENDOR` and `ONIE_MACHINE` is separated by an underscore.
* `platform.conf`: contains platform specific ONIE installer variables and
functions usually found in the ONIE repo.

Create `meta-mion-<ONL_VENDOR>/recipes-platform/` (if it doesn't exist) and
populate the following as needed:

* Directory `onlpv1/<ONL_VENDOR>-<ONL_MACHINE>/` and Directory/file
`onlpv1/onplv1_%.bbappend` -- This contains the ONLP specific patches.

## Kernel Configuration

To Modify the kernel config and add defconfig files, Create the directory path:

* `meta-mion-bsp/meta-mion-<ONL_VENDOR>/recipes-kernel/linux/<MACHINE>/`

Now add a kernel `defconfig` in the above directory -- it might be possible to
generate this file using ONL or base it on a similar system already in
meta-mion-bsp.

* Add any required config fragments (*.cfg)

Now Modify
`meta-mion-bsp/meta-mion-<ONL_VENDOR>/recipes-kernel/linux/linux-yocto_<VER>.bbappend`
and add the following defined variables:

* `KMACHINE_<MACHINE>`
* `KBRANCH_<MACHINE>`
* `SRC_URI_append_<MACHINE>`
* `SRCREV_machine_<MACHINE>`
* `KERNEL_EXTRA_FEATURES_<MACHINE>`
* Add `<MACHINE>` to `COMPATIBLE_MACHINE`

See
[linux-yocto_5.4.bbappend](https://github.com/NetworkGradeLinux/meta-mion-bsp/blob/dunfell-next/meta-mion-accton/recipes-kernel/linux/linux-yocto_5.4.bbappend)
for an example with the accton-asgvolt64.

## Platform recipes

Like the Linux kernel recipe above, some machine specific variables may need
to be set, or require overrides due to the nature of platform implementations
within ONL. Examples include `EXTRA_OEMAKE_append` to set the needed ARCH, and
`do_install` (either to overwrite it or append/prepend).

Also, you will likely need to patch the Makefile within the platform’s
onlp/builds directory to set `FILTER` from `src` to
`<ONIE_VENDOR>_<ONIE_ARCH>_<ONIE_MACHINE>`.

This part of the port is very vendor and platform specific and tends to require
the most effort.
