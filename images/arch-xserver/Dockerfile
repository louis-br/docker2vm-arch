FROM docker.io/archlinux:latest
RUN pacman --sync --refresh --noconfirm xorg xorg-server xorg-xinit
RUN pacman --sync --noconfirm xterm xorg-xclock xorg-twm
RUN echo "root:root" | chpasswd

COPY Xwrapper.config /etc/X11/Xwrapper.config
COPY install.conf /etc/systemd/system/systemd-firstboot.service.d/install.conf
COPY x11-autologin.service /etc/systemd/system/x11-autologin.service
RUN systemctl enable x11-autologin.service
RUN systemctl mask getty@.service autovt@.service
#console-getty.service container-getty@.service serial-getty@.service

RUN groupadd user && \
    useradd --create-home --gid user --shell /bin/bash --password user user && \
    usermod --gid user user && \
    echo "user:user" | chpasswd

#RUN chown --recursive user:user /tmp/.X11-unix
WORKDIR /tmp/.X11-unix/
RUN chown --recursive user:user .
USER user
WORKDIR /home/user/
RUN touch .Xauthority

#file /home/user/.Xauthority does not exist