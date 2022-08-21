#!/bin/sh
podman run \
  --rm \
  -p 5000:5000 \
  --name registry \
  -v $PWD/data:/var/lib/registry \
  registry:2