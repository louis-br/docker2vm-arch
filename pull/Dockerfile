# syntax=docker/dockerfile:1-labs
FROM docker2vm-arch:base
RUN mv /var/lib/containers /tmp/containers
RUN --mount=type=tmpfs,target=/var/lib/containers --security=insecure \
    podman pull --tls-verify=false localhost:5000/arch-xserver && \
    mv /var/lib/containers /tmp/containers
RUN mv /tmp/containers /var/lib/containers