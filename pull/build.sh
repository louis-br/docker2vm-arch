#!/bin/sh
set -x
export DISTRO=docker2vm-arch
export COMPOSE_FILE=../../../docker-compose.base.yml:../docker-compose.yml
docker compose build || exit 1
#docker buildx create --use --name insecure-builder --buildkitd-flags '--allow-insecure-entitlement security.insecure'
#docker buildx build --load --progress plain --allow security.insecure -t docker2vm-arch:latest .
#docker buildx rm insecure-builder
docker rm --force docker2vm-arch-pull
docker compose run --name docker2vm-arch-pull base /pull.sh
docker commit --message "podman pull" docker2vm-arch-pull docker2vm-arch:latest
docker rm --force docker2vm-arch-pull
#docker-compose rm docker2vm-archbase