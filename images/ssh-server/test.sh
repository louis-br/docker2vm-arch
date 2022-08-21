#!/bin/sh
podman build -t ssh-server .
podman run --rm -i -t --entrypoint sh --publish=2022:22 ssh-server
#--network=bridge:alias=ssh,ip=127.0.0.2