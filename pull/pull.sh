#!/bin/sh
cp --archive /var/lib/containers /tmp/containers
rm -rf /var/lib/containers
ln --symbolic /tmp/containers /var/lib/containers
for image in arch-xserver ubuntu-desktop; do
    podman pull --tls-verify=false host.docker.internal:5000/$image
done
rm -f /var/lib/containers
#cd /tmp/containers
#mkdir /var/lib/containers
#tar cf - . | tar xf - -C /var/lib/containers
cp --archive /tmp/containers /var/lib/containers
rm /pull.sh