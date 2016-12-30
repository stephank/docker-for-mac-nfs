# docker-for-mac-nfs

This is a hack to setup NFS for `/Users` in Docker for Mac, for those of us who
disagree with the filesystem performance of the stock installation. It is
tested on macOS Sierra with Docker for Mac 1.12.

**If you're using this, you'll do so at your own risk.** You'll likely need to
rerun the setup on every upgrade of Docker for Mac.

## Specifics

Docker for Mac transparently runs a virtual machine, which boots from a
ramdisk. The ramdisk is an Alpine Linux based system called Moby. Shares
configured in the preferences are normally mounted with a custom FUSE
filesystem called `osxfs`, which has less than stellar performance.

These scripts modify the ramdisk to setup NFS instead. The `import.sh` script
imports the stock ramdisk into a Docker image. The `make.sh` script starts a
container from that image, copies in the files from `extra/`, and runs
`container-script.sh`. The container filesystem is then dumped back to a
ramdisk, ready for use.

The current setup is to add the `nfs-utils` package, and a custom init script
to mount the share. (Simply adding an entry to `/etc/fstab` seems to not work.)

## Setup

 - Install and run Docker for Mac.
 - In the Docker for Mac preferences, remove the `/Users` share.
 - Add a `/Users` export to `/etc/exports` on your Mac:

```
# Where 501 is your user ID, and 20 your group ID. See the output of `id`.
/Users -mapall=501:20 localhost
```

 - Add the following line to `/etc/nfs.conf`:

```
nfs.server.mount.require_resv_port = 0
```

 - Restart `nfsd`:

```sh
sudo nfsd restart
```

 - Create the new `initrd.img`:

```sh
./import.sh
./make.sh
```

 - Quit Docker for Mac.

 - Backup the original `initrd.img`, and replace it with the new one:

```sh
mv /Applications/Docker.app/Contents/Resources/moby/initrd.img ~/docker-for-mac-initrd.img
mv ./initrd.img /Applications/Docker.app/Contents/Resources/moby/initrd.img
```

 - Restart Docker for Mac.
 - Profit.
