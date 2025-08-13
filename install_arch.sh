#!/bin/sh

sudo pacman -S \
alacritty \
bat \
blueman \
bluez \
brightnessctl \
discord \
dunst \
firefox \
fzf \
gnome-calculator \
gnome-calendar \
grim \
hypridle \
hyprland \
hyprlock \
hyprpaper \
man \
nautilus \
neovim \
noto-fonts-emoji \
nwg-look \
openssh \
otf-font-awesome \
pipewire \
qt5-wayland \
qt6-wayland \
slurp \
ttf-jetbrains-mono-nerd \
waybar \
wayland \
wireplumber \
wofi \
xdg-desktop-portal-hyprland \

sudo systemctl enable bluetooth.service blueman-mechanism.service
