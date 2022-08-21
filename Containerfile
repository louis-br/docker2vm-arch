FROM docker.io/archlinux:latest
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

RUN pacman --sync --refresh --noconfirm python-pip
RUN pip3 install https://github.com/containers/podman-compose/archive/devel.tar.gz

COPY images/update-config/systemd-units /root/systemd-units
COPY images/update-config/format-media.sh /usr/local/bin/format-media.sh
COPY images/update-config/update.sh /usr/local/bin/update.sh
RUN chmod +x /usr/local/bin/format-media.sh
RUN chmod +x /usr/local/bin/update.sh

COPY media-config /media-config

WORKDIR /etc/systemd/system/
RUN ln --symbolic /root/systemd-units/update-config.service
RUN ln --symbolic /root/systemd-units/ssh-server.service
RUN ln --symbolic /root/systemd-units/media.mount
RUN ln --symbolic /root/systemd-units/media-server.service
RUN ln --symbolic /root/systemd-units/arch-xserver.service
RUN ln --symbolic /root/systemd-units/ubuntu-desktop.service
WORKDIR /

COPY install.conf /etc/systemd/system/systemd-firstboot.service.d/install.conf
COPY 20-wired.network /etc/systemd/network/20-wired.network

RUN systemctl enable ssh-server.service
RUN systemctl enable media.mount

RUN groupadd user && \
    useradd --create-home --gid user --shell /bin/bash --password user user && \
    usermod --gid user user && \
    echo "user:user" | chpasswd

#RUN systemctl enable media-server.service
#podman load --input /tmp/ubuntu-desktop.tar.gz
#podman run --interactive --tty --rm --systemd always --user root ubuntu-desktop /sbin/init 
#podman run --interactive --tty --privileged --volume /usr/lib/dri:/usr/lib/dri:ro arch-xserver bash
#podman run -i -t --privileged --rootfs /:O /sbin/init
#/var/lib/containers/storage