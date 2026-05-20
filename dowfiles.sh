#!/bin/bash

DOTFILES_DIR="$HOME/dowfiles"
PKGS_DIR="$DOTFILES_DIR/packages"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

IS_WSL=false
[[ $(grep -Ei "(Microsoft|WSL)" /proc/version) ]] && IS_WSL=true

hook_config() {
    echo -ne "  ${BLUE}.config:${NC} "

    if [ ! -e "$HOME/.config" ]; then
        mkdir -p "$HOME/.config"
        echo -e "${GREEN}Created${NC}"
        return 0
    fi

    if [ ! -d "$HOME/.config" ]; then
        echo -ne "${RED}Is not a directory${NC}"
    else
        echo -e "${GREEN}OK${NC}"
    fi
}

hook_alacritty() {
    if pacman -Qi alacritty > /dev/null 2>&1; then
        echo -ne "  ${BLUE}alacritty:${NC} "

        if [ ! -L "$HOME/.config/alacritty" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow alacritty
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_bat() {
    if pacman -Qi bat > /dev/null 2>&1; then
        echo -ne "  ${BLUE}bat:${NC} "

        if [ ! -L "$HOME/.config/bat" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow bat
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_dunst() {
    if pacman -Qi dunst > /dev/null 2>&1; then
        echo -ne "  ${BLUE}dunst:${NC} "

        if [ ! -L "$HOME/.config/dunst" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow dunst
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_fonts() {
    if [[ "$IS_WSL" == false ]];then
        echo -ne "  ${BLUE}fonts:${NC} "
        if fc-cache -fv >/dev/null 2>&1; then
            echo -e "${GREEN}OK${NC}"
        else
            echo -ne "${RED}KO${NC}"
        fi
    fi
}

hook_git() {
    if pacman -Qi git > /dev/null 2>&1; then
        echo -ne "  ${BLUE}git:${NC} "

        if [ ! -L "$HOME/.gitconfig" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow git
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_hyprland() {
    if pacman -Qi hyprland > /dev/null 2>&1; then
        echo -ne "  ${BLUE}hyprland:${NC} "

        if [ ! -L "$HOME/.config/hypr" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow hyprland
            echo -ne "${GREEN}OK${NC}"

            read -r -p "Desktop/Laptop usage ? (d/l):" system
            case $system in
                [Dd]*)
                    ln -s ~/.config/hypr/hyprland/desktop.conf ~/.config/hypr/hyprland.conf
                    echo -e "${GREEN}Desktop OK${NC}"
                ;;
                [Ll]*)
                    ln -s ~/.config/hypr/hyprland/laptop.conf ~/.config/hypr/hyprland.conf
                    echo -e "${GREEN}Laptop OK${NC}"
                ;;
                *)
                    echo -e "${YELLOW}No usage${NC}"
                ;;
            esac
        else
            echo -e "${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_ly() {
    if pacman -Qi ly > /dev/null 2>&1; then
        echo -ne "  ${BLUE}ly:${NC} "

        if systemctl is-enabled ly@tty1.service >/dev/null 2>&1 && \
            ! systemctl is-enabled getty@ttyp1.service >/dev/null 2>&1; then
            echo -e "${GREEN}Enabled${NC}"
        else
            echo -e "${YELLOW}Enabling...${NC}"
            sudo systemctl disable getty@tty1.service
            sudo systemctl enable ly@tty1.service
            echo -e "${GREEN}OK${NC}"
        fi
    fi
}

hook_niri() {
    if pacman -Qi niri > /dev/null 2>&1; then
        echo -ne "  ${BLUE}niri:${NC} "

        if [ ! -L "$HOME/.config/niri" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow niri
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_rofi() {
    if pacman -Qi rofi > /dev/null 2>&1; then
        echo -ne "  ${BLUE}rofi:${NC} "

        if [ ! -L "$HOME/.config/rofi" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow rofi
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_waybar() {
    if pacman -Qi waybar > /dev/null 2>&1; then
        echo -ne "  ${BLUE}waybar:${NC} "

        # Service
        if systemctl --user is-enabled waybar.service >/dev/null 2>&1; then
            echo -ne "${GREEN}Enabled${NC}"
        else
            echo -ne "${YELLOW}Enabling...${NC}"
            systemctl --user enable waybar.service
            echo -ne "${GREEN}OK${NC}"
        fi

        # Stow
        if [ ! -L "$HOME/.config/waybar" ]; then
            echo -ne " - ${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow waybar
            echo -e "${GREEN}OK${NC}"
        else
            echo -e " - ${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_wayland() {
    if pacman -Qi wayland > /dev/null 2>&1; then
        echo -ne "  ${BLUE}wayland:${NC} "

        # Stow
        if [ ! -L "$HOME/.config/electron-flags.conf" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow wayland
            echo -ne "${GREEN}OK${NC}"
        else
            echo -ne "${GREEN}Stow OK${NC}"
        fi

        # Stow profile
        if [ ! -L "$HOME/.profile" ]; then
            echo -ne " - ${YELLOW}Stowing profile...${NC}"
            cd "$DOTFILES_DIR" && stow profile
            echo -e "${GREEN}OK${NC}"
        else
            echo -e " - ${GREEN}Stow profile OK${NC}"
        fi
    fi
}

hook_zed() {
    if pacman -Qi zeditor > /dev/null 2>&1; then
        echo -ne "  ${BLUE}zed:${NC} "

        if [ ! -L "$HOME/.config/zed" ]; then
            echo -ne "${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow zed
            echo -e "${GREEN}OK${NC}"
        else
            echo -e "${GREEN}Stow OK${NC}"
        fi
    fi
}

hook_zsh() {
    if pacman -Qi zsh > /dev/null 2>&1; then
        echo -ne "  ${BLUE}zsh:${NC} "

        # Default shell
        local current_shell=$(getent passwd "$USER" | cut -d: -f7)
        local zsh_path=/usr/bin/zsh

        if [[ "$current_shell" == "$zsh_path" ]]; then
            echo -ne "${GREEN}Enabled${NC}"
        else
            echo -ne "${YELLOW}Current shell is $current_shell. Enabling..${NC}"
            if chsh -s "$zsh_path"; then
                echo -ne "${GREEN}OK${NC}"
            else
                echo -ne "${RED}KO${NC}"
            fi
        fi

        # Stow
        if [ ! -L "$HOME/.zshrc" ]; then
            echo -ne " - ${YELLOW}Stowing...${NC}"
            cd "$DOTFILES_DIR" && stow zsh
            echo -ne "${GREEN}OK${NC}"
        else
            echo -ne " - ${GREEN}Stow OK${NC}"
        fi

        # Welcome
        if [ ! -L "$HOME/.config/zsh/custom/welcome.zsh" ]; then
            ln -s "$HOME/.config/zsh/welcome.zsh" "$HOME/.config/zsh/custom/welcome.zsh"
            echo -e " - ${GREEN}Welcome Created${NC}"
        else
            echo -e " - ${GREEN}Welcome OK${NC}"
        fi
    fi
}

run_all_hooks() {
    echo -e "${BLUE}Check configurations${NC}"
    hook_config # Must be first
    hook_alacritty
    hook_bat
    hook_dunst
    hook_fonts
    hook_git
    hook_hyprland
    hook_ly
    hook_niri
    hook_rofi
    hook_wayland
    hook_waybar
    hook_zed
    hook_zsh
}

check_packages() {
    local categories_output=()

    echo -e "${BLUE}Check packages${NC}"

    for file in "$PKGS_DIR"/*.txt; do
        if [[ -f "$file" ]]; then
            local cat_name=$(basename "$file" .txt)
            local current_cat_pkgs=()

            [[ "$IS_WSL" == true && "$cat_name" != "base" ]] && continue

            while IFS= read -r pkg || [[ -n "$line" ]]; do
                [[ -z "$pkg" || "$pkg" == \#* ]] && continue

                if pacman -Qi "$pkg" > /dev/null 2>&1; then
                    current_cat_pkgs+=("$pkg")
                else
                    current_cat_pkgs+=("${RED}$pkg${NC}")
                fi
            done < "$file"

            if [ ${#current_cat_pkgs[@]} -gt 0 ]; then
                local temp_string=$(printf "%b, " "${current_cat_pkgs[@]}")
                local joined_pkgs=${temp_string%, }
                categories_output+=("  ${BLUE}${cat_name^}${NC}: $joined_pkgs")
            fi
        fi
    done

    printf "%b\n\n" "$(IFS=$'\n'; echo "${categories_output[*]}")"
}

install() {
    local file=("$PKGS_DIR"/"$1".txt)
    local pkgs=()

    if [[ -f "$file" ]]; then
        while IFS= read -r pkg || [[ -n "$line" ]]; do
            [[ -z "$pkg" || "$pkg" == \#* ]] && continue
            pkgs+=("$pkg")
        done < "$file"
    fi

    echo -e "${BLUE}Installing from $1${NC}"

    if [ ${#pkgs[@]} -gt 0 ]; then
        echo -e "${YELLOW}${#pkgs[@]} packages will be installed.${NC}\n"
        sudo pacman -Sy --needed "${pkgs[@]}"
    else
        echo -e "${GREEN}Nothing to do${NC}"
    fi
}

show_help() {
    echo "Usage: dowfiles [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  check    Check installation configuration"
    echo "  install  Install missing packages and configuration"
    echo "  help     Show this message"
}

# Main
clear
echo -ne "${BLUE}Dowfiles Manager${NC} - "
if [[ "$IS_WSL" == true ]]; then
    echo -e "${YELLOW}WSL${NC}\n"
else
    echo -e "${YELLOW}Native${NC}\n"
fi

case "$1" in
    check)
        check_packages
        run_all_hooks
        ;;
    install)
        install $2
        run_all_hooks
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        if [[ -z "$1" ]]; then
            show_help
        else
            echo -e "${RED}Error: Unknown command $1${NC}\n"
            show_help
            exit 1
        fi
        ;;
esac
