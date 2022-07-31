#!/bin/bash
for image in arch-xserver ubuntu-desktop; do
    running=$(systemctl is-active --quiet $image)
    systemctl stop $image
    podman image rm -f localhost/$image
    podman pull --tls-verify=false 10.0.2.2:5000/$image
    if [ $running ]; then
        systemctl start $image
    fi
done