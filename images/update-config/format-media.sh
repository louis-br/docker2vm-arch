#!/bin/sh
#hello world

if [ -z "$TARGET" ]; then
    echo "TARGET not set"
    exit 1
fi

LABEL="Media"
UUID="27780233-a2dd-4d0b-bcca-85e15f56e1d3"

parted --script "$TARGET" \
        mklabel gpt \
        mkpart "$LABEL" ext4 0% 100% \
        unit B print || exit 1

mkfs.ext4 -vF -t ext4 -U $UUID "${TARGET}1" || exit 1