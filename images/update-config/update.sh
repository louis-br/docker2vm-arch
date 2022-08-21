#!/bin/bash

systemctl start update-config
systemctl daemon-reload

for image in update-config ssh-server arch-xserver ubuntu-desktop; do
    running=$(systemctl is-active --quiet $image)
    systemctl stop $image
    podman pull --tls-verify=false 10.0.2.2:5000/$image
    podman image rm -f localhost:5000/$image
    if [ $running ]; then
        systemctl start $image
    fi
done

systemctl start update-config
systemctl daemon-reload