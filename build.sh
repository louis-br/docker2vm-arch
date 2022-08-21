#!/bin/sh
#set -x

#if ! mountpoint -q output/; then
#    sudo mount -t tmpfs -o size=10G tmpfs output
#fi

mkdir --parents cache/containers
mkdir --parents output/rootfs

./build-images.sh

sudo podman build --tag=docker2vm-base . || exit 1
sudo podman build \
    --no-cache \
    --file=Containerfile.pull \
    --cap-add=CAP_SYS_ADMIN \
    --volume="$PWD/cache/containers:/var/lib/containers" \
    --tag=docker2vm-arch . || exit 1

sudo podman build --tag=docker2vm-rsync rsync/ || exit 1

sudo podman create --name=docker2vm-export docker2vm-arch || exit 1

mnt=$(sudo podman mount docker2vm-export)

if [ ! -z "$mnt" ]; then
    sudo podman run --rm \
        --network=none \
        --volume="$mnt:/rootfs":ro \
        --volume=./output/rootfs:/mnt/rootfs \
        docker2vm-rsync \
            --archive \
            --executability \
            --acls \
            --xattrs \
            --specials \
            --atimes \
            --delete \
            --force \
            --stats \
            --human-readable \
            --info=progress2 \
            --filter="- var/lib/containers" \
            /rootfs/ /mnt/rootfs || exit 1

    sudo podman run --rm \
        --network=none \
        --volume=./cache/containers:/containers:ro \
        --volume=./output/rootfs:/mnt/rootfs \
        docker2vm-rsync \
            --archive \
            --executability \
            --acls \
            --xattrs \
            --specials \
            --atimes \
            --delete \
            --force \
            --stats \
            --human-readable \
            --info=progress2 \
            /containers/ /mnt/rootfs/var/lib/containers || exit 1
fi

if [ "$1" = "disk" ]; then
    cd ../../
    DISTRO=docker2vm-arch ./build.sh
fi

sudo podman umount docker2vm-export

#if command -v pv; then
#    size=$(stat --printf="%s" output/rootfs.tar 2> /dev/null)
#    size=${size:-2G}
#    sudo sh -c \
#    "podman export docker2vm-export \
#     | pv --size $size -p -t -r -b \
#     > output/rootfs.tar"
#else
#    sudo podman export --output="output/rootfs.tar" docker2vm-export
#fi

sudo podman container rm docker2vm-export