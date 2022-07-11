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