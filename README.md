# dowfiles

This repo contains all my dot files

![Screenshot example](https://github.com/Dowdow/dowfiles/blob/main/screenshot.png?raw=true)

## Setup

```bash
# Install dependencies
sudo pacman -Sy --needed git

# Clone the repo with submodules in your home directory
git clone --recurse-submodules https://github.com/Dowdow/dowfiles.git
# If you forgot the --recurse-submodules option
git submodule update --init

# Use the script to install WSL or native
./dowfiles/dowfiles.sh
```

### Stow

```bash
# Install the config with symlinks
cd dowfiles
stow */ # to link everything
stow git zsh # to use only git and zsh
```

### Custom zsh config

The custom config can be added in `zsh/.config/zsh/custom` and will be ignored by git.

#### Nvidia

Documentation: [Arch Nvidia](https://wiki.archlinux.org/title/NVIDIA) and [Hyprland Nvidia](https://wiki.hyprland.org/Nvidia/).

```bash
sudo pacman -Sy --needed linux-headers nvidia-dkms libva-nvidia-driver
```

#### Bluetooth
```bash
sudo pacman -Sy --needed blueman bluez
sudo systemctl enable bluetooth.service blueman-mechanism.service
```

### UI Config

Use `nwg-look` or `GTK Settings` with rofi to set prefer dark mode and set `JetBrainsMono Nerd Regular` as default font.

### Splash screen

Add `quiet splash` at the end of the `/etc/kernet/cmdline` file.

Copy splash file to `/efi/loader/splash.bmp` or `/boot/loader/splash.bmp`.

Edit the `/etc/mkinitcpio.d/linux.preset` file, and change the default splash path in the options : `default_options="--splash /efi/loader/splash.bmp"`

Run `sudo mkinitcpio -P`.
