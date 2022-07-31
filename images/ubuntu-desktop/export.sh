#!/bin/sh
container=$(docker create ubuntu-desktop)
docker export "$container" -o ../exports/ubuntu-desktop.tar
docker rm "$container"