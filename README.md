# dowfile

This repo contains all my dot files

## Setup

```bash
# Install dependencies
sudo apt install -y git stow zsh zsh-syntax-highlighting

# Clone the repo with submodules in your home directory
git clone --recurse-submodules https://github.com/Dowdow/dowfiles.git

# Install the config with symlinks
cd dowfiles
stow .

# Make zsh as default shell
chsh -s $(which zsh)

# Restart your terminal
```