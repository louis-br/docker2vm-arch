#!/bin/sh
for image in arch-xserver ubuntu-desktop; do
    docker tag $image localhost:5000/$image
    docker push localhost:5000/$image
done