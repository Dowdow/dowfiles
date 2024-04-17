# dowfiles

This repo contains all my dot files

![Screenshot example](https://github.com/Dowdow/dowfiles/blob/main/screenshot.png?raw=true)

## Setup

```bash
# Install dependencies
sudo apt install -y git stow zsh

# Clone the repo with submodules in your home directory
git clone --recurse-submodules https://github.com/Dowdow/dowfiles.git

# Install the config with symlinks
cd dowfiles
stow .

# Make zsh as default shell
chsh -s $(which zsh)

# Restart your terminal
```

## Custom config

The custom config can be added in `.zsh/custom` and will be ignored by git.

## Windows Terminal (WSL) Theme

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
