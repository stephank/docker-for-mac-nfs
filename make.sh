#!/bin/bash

set -xe

# Create a container.
container="$(docker create -i alpine:latest /bin/sh)"
# Clean it up when we exit.
trap "docker rm \"${container}\"" exit

# Copy original initrd.
zcat < original.tar.gz | docker cp - "${container}":/srv/
# Copy extra files.
tar -C extra -c . | docker cp - "${container}":/srv/
# Run the script that makes additional modifications.
docker start -ai "${container}" < container-script.sh
# Extract the output.
docker cp "${container}":/output.img initrd.img
