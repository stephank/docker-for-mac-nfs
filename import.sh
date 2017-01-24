#!/bin/bash

INITRD_PATH="/Applications/Docker.app/Contents/Resources/moby/initrd.img"

set -xe

# Convert the original initrd to a tarball.
tar -czf original.tar.gz "@${INITRD_PATH}"
