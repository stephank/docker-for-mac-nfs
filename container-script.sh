#!/bin/sh

set -xe

chroot /srv/ /bin/sh << EOF
apk update
apk add nfs-utils
EOF

cd /srv/
find . | cpio -o -H newc | gzip -9 > /output.img
