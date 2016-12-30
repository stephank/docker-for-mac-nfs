#!/bin/bash

INITRD_PATH="/Applications/Docker.app/Contents/Resources/moby/initrd.img"
INITRD_TAG="dummy.example/moby-initrd:latest"

set -xe

# Import the initrd as a docker image.
tar -c "@${INITRD_PATH}" | docker import - "${INITRD_TAG}"
