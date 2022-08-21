#!/bin/sh

for image in update-config ssh-server arch-xserver ubuntu-desktop; do
    cd images/$image
    sudo podman build --tag=$image . || exit 1
    sudo podman tag $image localhost:5000/$image || exit 1
    sudo podman push --tls-verify=false localhost:5000/$image || exit 1
    cd ../..
done