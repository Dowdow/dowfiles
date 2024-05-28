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

# Install the config with symlinks
cd dowfiles
stow */ # to link everything
stow git zsh # to use only git and zsh

# Make zsh as default shell
chsh -s $(which zsh)

# Restart your terminal
```
## Arch

Arch configuration for hyprland usage

### Packages

```bash
sudo pacman -S alacritty discord dolphin dunst firefox hyprpaper hyprland nwg-look openssh pipewire qt5-wayland qt6-wayland ttf-font-awesome ttf-jetbrains-mono-nerd waybar wayland wofi
```

### UI Config

Use `nwg-look` or `GTK Settings` with wofi to set prefer dark mode and set `JetBrains Mono Nerd Regular` as default font.

### Nvidia config

[Arch Nvidia](https://wiki.archlinux.org/title/NVIDIA)

[Hyprland Nvidia](https://wiki.hyprland.org/Nvidia/)

```bash
# Nvidia packages
sudo pacman -S libva-nvidia-driver linux-headers nvidia-dkms

# Automatic KMS late loading (maybe need reboot)
modprobe nvidia_drm modeset=1
cat /sys/module/nvidia_drm/parameters/modeset # Should return Y

# Grub config
sudo nano /etc/default/grub
# GRUB_CMDLINE_LINUX_DEFAULT=" ... nvidia_drm.modeset=1"
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Mkinitcpio config
sudo nano /etc/mkinitcpio.conf
# MODULES=( ... nvidia nvidia_modeset nvidia_uvm nvidia_drm)
sudo mkinitcpio -P

# Power management
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
modprobe nvidia NVreg_PreserveVideoMemoryAllocations=1
```

## Zsh

### Custom zsh config

The custom config can be added in `zsh/.config/zsh/custom` and will be ignored by git.

### Windows Terminal (WSL) Theme

Color theme to add as Json under the `"schemes":` array.

```json
{
  "background": "#0D101B",
  "black": "#000009",
  "blue": "#58B6CA",
  "brightBlack": "#1F222D",
  "brightBlue": "#8BE9FD",
  "brightCyan": "#C0B7F9",
  "brightGreen": "#A5FFE1",
  "brightPurple": "#97BBF7",
  "brightRed": "#EE829F",
  "brightWhite": "#FFFFFF",
  "brightYellow": "#F99170",
  "cursorColor": "#EBEEF9",
  "cyan": "#8D84C6",
  "foreground": "#EBEEF9",
  "green": "#72CCAE",
  "name": "Dowdow Theme",
  "purple": "#6488C4",
  "red": "#BB4F6C",
  "selectionBackground": "#FFFFFF",
  "white": "#858893",
  "yellow": "#C65E3D"
}
```
