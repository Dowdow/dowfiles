#!/bin/sh

sudo pacman -S \
alacritty \
bat \
blueman \
bluez \
brightnessctl \
discord \
dolphin \
dunst \
firefox \
fzf \
gnome-calculator \
grim \
hypridle \
hyprland \
hyprlock \
hyprpaper \
man \
noto-fonts-emoji \
nwg-look \
openssh \
pipewire \
qt5-wayland \
qt6-wayland \
slurp \
ttf-font-awesome \
ttf-jetbrains-mono-nerd \
waybar \
wayland \
wireplumber \
wofi \

sudo systemctl enable bluetooth.service blueman-mechanism.service