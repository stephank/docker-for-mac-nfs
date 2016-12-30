#!/bin/bash

INITRD_TAG="dummy.example/moby-initrd:latest"

set -xe

# Create a container.
container="$(docker create -i "${INITRD_TAG}" /bin/sh)"
# Clean it up when we exit.
trap "docker rm \"${container}\"" exit

# Copy extra files.
tar -C extra -c . | docker cp - "${container}":/
# Run the script that makes additional modifications.
docker start -ai "${container}" < container-script.sh

# Build a new initrd.
docker export "${container}" | tar -cz --format newc -f initrd.img @-
