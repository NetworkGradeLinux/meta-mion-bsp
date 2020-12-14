# QEMU mion Images

This layer provides a bootable x86-64 qemu onlpv1 image, which can be used for
testing purposes.

## Build Instructions

The qemu image varies from the usual invocation of the build script in that only
the machine name is used. To build the image, run:
`../mc_build.sh -v qemu -m qemux86-64 -h host-onie:mion-image-onlpv1`

## Running qemu

From the build directory, `runqemu tmp-glibc/deploy/images/qemux86-64/`. This
will start the latest built image. 

> If you encounter issues with setting up networking/tap devices, read the
relevant
[Yocto Project Testing](https://www.yoctoproject.org/docs/current/dev-manual/dev-manual.html#qemu-image-enabling-tests)
documentation on how to do so.

After starting the image, login on a separate console with
`ssh root@192.168.7.2`. Note that it may take a few seconds after starting until
you are able to login. 

> If you rebuild, you will need to remove it from known hosts before using ssh
  again: `ssh-keygen -f "/home/<USER>/.ssh/known_hosts" -R "192.168.7.2"`
    
## Known Issues

Please note that at this time, only basic QA/testing has been performed for this
image, so other issues may exist. 

* `onlpdump.py` fails due to linking issues in the build process. When linked
  manually, it fails with an error of a supposedly non-existent `onlp.init`
  attribute.
