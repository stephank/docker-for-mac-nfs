#!/bin/bash

INITRD_PATH="/Applications/Docker.app/Contents/Resources/moby/initrd.img"

set -xe

# Convert the original initrd to a tarball.
tar -czf original.tar.gz "@${INITRD_PATH}"

# The initrd is two archives concatenated. Find the tail.
DWORD_OFFSET="$(xxd -p -c 4 -s 4 "${INITRD_PATH}" | grep -n -m 1 '1f8b0800' | cut -f 1 -d :)"
OFFSET="$((DWORD_OFFSET * 4))"
dd if="${INITRD_PATH}" of=tail.bin bs="${OFFSET}" skip=1
