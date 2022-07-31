#!/bin/sh
container=$(docker create arch-xserver)
docker export "$container" -o ../exports/arch-xserver.tar
docker rm "$container"