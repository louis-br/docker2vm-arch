#!/bin/bash
set -a
VMLINUZ=/boot/vmlinuz-linux
INITRAMFS=/boot/initramfs-linux.img
# console=tty0
KERNEL_PARAMETERS="console=ttyS0 rootfstype=ext4 root=UUID=${UUID} init=/sbin/init rw ${KERNEL_PARAMETERS}"