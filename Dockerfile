FROM archlinux:latest
RUN pacman --sync --refresh --noconfirm reflector
RUN reflector --save /etc/pacman.d/mirrorlist \
              --protocol https \
              --latest 5 \
              --sort rate
RUN pacman --sync --noconfirm mkinitcpio
RUN sed -i 's/autodetect //' /etc/mkinitcpio.conf
RUN pacman --sync --noconfirm base linux linux-firmware
RUN echo "root:root" | chpasswd
RUN pacman --sync --noconfirm docker
RUN pacman --sync --noconfirm podman
RUN pacman --sync --noconfirm nano

#COPY --from=container-store:latest / /var/lib/
#COPY images/exports/arch-xserver.tar.gz /images/arch-xserver.tar.gz
#COPY images/exports/ubuntu-desktop.tar.gz /images/ubuntu-desktop.tar.gz
COPY pull/pull.sh /pull.sh
RUN chmod +x /pull.sh

COPY images/arch-xserver/arch-xserver.service /etc/systemd/system/arch-xserver.service
COPY images/ubuntu-desktop/ubuntu-desktop.service /etc/systemd/system/ubuntu-desktop.service

COPY update.sh /update.sh
RUN chmod +x /update.sh

COPY install.conf /etc/systemd/system/systemd-firstboot.service.d/install.conf
COPY 20-wired.network /etc/systemd/network/20-wired.network

RUN systemctl enable arch-xserver.service
#podman load --input /tmp/ubuntu-desktop.tar.gz
#podman run --interactive --tty --rm --systemd always --user root ubuntu-desktop /sbin/init 
#podman run --interactive --tty --privileged --volume /usr/lib/dri:/usr/lib/dri:ro arch-xserver bash
#podman run -i -t --privileged --rootfs /:O /sbin/init
#/var/lib/containers/storage