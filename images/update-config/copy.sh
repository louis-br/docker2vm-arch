#!/bin/sh
rsync \
    --archive \
    --delete \
    --human-readable \
    --progress \
    /systemd-units/ /mnt/systemd-units

cp -f /update.sh /mnt/bin/update.sh