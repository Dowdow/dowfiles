# dowfiles

This repo contains all my dot files

![Screenshot example](https://github.com/Dowdow/dowfiles/blob/main/screenshot.png?raw=true)

## Setup

```bash
# Install dependencies
sudo apt install -y git stow zsh
sudo pacman -S git stow zsh

# Clone the repo with submodules in your home directory
git clone --recurse-submodules https://github.com/Dowdow/dowfiles.git
# If you forgot the --recurse-submodules option
git submodule update --init

# Install the config with symlinks
cd dowfiles
stow */ # to link everything
stow git zsh # to use only git and zsh

# Make zsh as default shell
chsh -s $(which zsh)

# Restart your terminal
```

### Custom zsh config

The custom config can be added in `zsh/.config/zsh/custom` and will be ignored by git.

## Arch

Arch configuration for hyprland usage.

### Packages

#### System

```bash
sudo pacman -S bat brightnessctl dunst fzf git grim hypridle hyprland hyprlock hyprpaper man nano noto-fonts-emoji nwg-look openssh otf-font-awesome pacman-contrib pipewire qt5-wayland qt6-wayland slurp ttf-jetbrains-mono-nerd waybar wayland wireplumber wofi xdg-desktop-portal-hyprland
```

#### Nvidia

Documentation: [Arch Nvidia](https://wiki.archlinux.org/title/NVIDIA) and [Hyprland Nvidia](https://wiki.hyprland.org/Nvidia/).

```bash
sudo pacman -S linux-headers nvidia-dkms libva-nvidia-driver
```

#### Applications
```bash
sudo pacman -S alacritty discord firefox gnome-calculator gnome-calendar nautilus neovim
```

#### Bluetooth
```bash
sudo pacman blueman bluez
sudo systemctl enable bluetooth.service blueman-mechanism.service
```

### Hyprland config

```bash
# Desktop
ln -s ~/.config/hypr/hyprland/desktop.conf ~/.config/hypr/hyprland.conf
# Laptop
ln -s ~/.config/hypr/hyprland/laptop.conf ~/.config/hypr/hyprland.conf
```

### UI Config

Use `nwg-look` or `GTK Settings` with wofi to set prefer dark mode and set `JetBrains Mono Nerd Regular` as default font.
