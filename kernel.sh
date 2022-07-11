#!/bin/bash
set -a
VMLINUZ=/boot/vmlinuz-linux
INITRAMFS=/boot/initramfs-linux.img
KERNEL_PARAMETERS="console=ttyS0 console=tty0 rootfstype=ext4 root=UUID=${UUID} init=/bin/sh ${KERNEL_PARAMETERS}"