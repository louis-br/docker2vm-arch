#!/bin/bash
systemctl stop arch-xserver
podman image rm localhost/arch-xserver
podman pull --tls-verify=false 10.0.2.2:5000/arch-xserver
systemctl start arch-xserver