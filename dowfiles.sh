#!/bin/bash
set -uo pipefail

DOTFILES_DIR="$HOME/dowfiles"
PKGS_DIR="$DOTFILES_DIR/packages"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

IS_WSL=false
grep -Eqi "(Microsoft|WSL)" /proc/version && IS_WSL=true

COLS=$(tput cols 2>/dev/null)
[[ -z "$COLS" ]] && COLS=80

STOW_APPS=(
    "alacritty|alacritty|alacritty|$HOME/.config/alacritty"
    "bat|bat|bat|$HOME/.config/bat"
    "dunst|dunst|dunst|$HOME/.config/dunst"
    "git|git|git|$HOME/.gitconfig"
    "niri|niri|niri|$HOME/.config/niri"
    "rofi|rofi|rofi|$HOME/.config/rofi"
    "zed|zeditor|zed|$HOME/.config/zed"
)

pkg_installed() { pacman -Qi "$1" &>/dev/null; }
is_stowed() { [[ -L "$1" ]]; }
do_stow() { (cd "$DOTFILES_DIR" && stow "$1"); }

label() { printf "  %-14s " "$1:"; }
kv()    { printf "%s=" "$1"; }
ok()    { printf "%b%s%b\n" "$GREEN" "$1" "$NC"; }
ko()    { printf "%b%s%b\n" "$RED" "$1" "$NC"; }
warn()  { printf "%b%s%b\n" "$YELLOW" "$1" "$NC"; }
okf()   { printf "%b%s%b " "$GREEN" "$1" "$NC"; }
kof()   { printf "%b%s%b " "$RED" "$1" "$NC"; }
warnf() { printf "%b%s%b " "$YELLOW" "$1" "$NC"; }

read_pkgs() {
    local file="$1" pkg
    [[ -f "$file" ]] || return 0
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
        [[ -z "$pkg" || "$pkg" == \#* ]] && continue
        printf '%s\n' "$pkg"
    done < "$file"
}

list_categories() {
    local f
    echo "Categories:"
    for f in "$PKGS_DIR"/*.txt; do
        [[ -f "$f" ]] && echo "  - $(basename "$f" .txt)"
    done
}

stow_if_missing() {
    local disp pkg dir marker
    IFS='|' read -r disp pkg dir marker <<< "$1"
    pkg_installed "$pkg" || return 0

    label "$disp"
    if is_stowed "$marker"; then
        ok "OK"
    else
        do_stow "$dir" && ok "stowed" || ko "KO"
    fi
}

hook_config() {
    label "config"
    if [[ ! -e "$HOME/.config" ]]; then
        mkdir -p "$HOME/.config"
        ok "created"
        return 0
    fi
    if [[ ! -d "$HOME/.config" ]]; then
        ko "not a directory"
    else
        ok "OK"
    fi
}

hook_fonts() {
    [[ "$IS_WSL" == true ]] && return 0
    label "fonts"
    fc-cache -f &>/dev/null && ok "OK" || ko "KO"
}

hook_hyprland() {
    pkg_installed hyprland || return 0
    label "hyprland"

    if is_stowed "$HOME/.config/hypr"; then
        ok "OK"
        return 0
    fi
    if ! do_stow hyprland; then
        ko "KO"
        return 1
    fi
    okf "stowed"

    read -r -p "desktop/laptop ? (d/l): " system
    case "$system" in
        [Dd]*) ln -s ~/.config/hypr/hyprland/desktop.conf ~/.config/hypr/hyprland.conf; ok "desktop" ;;
        [Ll]*) ln -s ~/.config/hypr/hyprland/laptop.conf ~/.config/hypr/hyprland.conf; ok "laptop" ;;
        *) warn "skipped" ;;
    esac
}

hook_ly() {
    pkg_installed ly || return 0
    label "ly"

    if systemctl is-enabled ly@tty1.service &>/dev/null && ! systemctl is-enabled getty@tty1.service &>/dev/null; then
        ok "OK"
        return 0
    fi

    warnf "needs enable"
    read -r -p "- disable getty@tty1, enable ly@tty1 ? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        sudo systemctl disable getty@tty1.service
        sudo systemctl enable ly@tty1.service
        ok "OK"
    else
        ok "skipped"
    fi
}

hook_waybar() {
    pkg_installed waybar || return 0
    label "waybar"

    kv service
    if systemctl --user is-enabled waybar.service &>/dev/null; then
        okf "OK"
    else
        systemctl --user enable waybar.service && okf "enabled" || kof "KO"
    fi

    kv stow
    if is_stowed "$HOME/.config/waybar"; then
        ok "OK"
    else
        do_stow waybar && ok "stowed" || ko "KO"
    fi
}

hook_wayland() {
    pkg_installed wayland || return 0
    label "wayland"

    kv stow
    if is_stowed "$HOME/.config/electron-flags.conf"; then
        okf "OK"
    else
        do_stow wayland && okf "stowed" || kof "KO"
    fi

    kv profile
    if is_stowed "$HOME/.profile"; then
        ok "OK"
    else
        do_stow profile && ok "stowed" || ko "KO"
    fi
}

hook_zsh() {
    pkg_installed zsh || return 0
    label "zsh"

    local current_shell zsh_path=/usr/bin/zsh
    current_shell=$(getent passwd "$USER" | cut -d: -f7)

    kv shell
    if [[ "$current_shell" == "$zsh_path" ]]; then
        okf "OK"
    else
        chsh -s "$zsh_path" && okf "OK" || kof "KO"
    fi

    kv stow
    if is_stowed "$HOME/.zshrc"; then
        okf "OK"
    else
        do_stow zsh && okf "stowed" || kof "KO"
    fi

    kv welcome
    if [[ -L "$HOME/.config/zsh/custom/welcome.zsh" ]]; then
        ok "OK"
    else
        ln -s "$HOME/.config/zsh/welcome.zsh" "$HOME/.config/zsh/custom/welcome.zsh"
        ok "created"
    fi
}

run_all_hooks() {
    echo -e "${BLUE}Configuration${NC}"
    hook_config

    local entry
    for entry in "${STOW_APPS[@]}"; do
        stow_if_missing "$entry"
    done

    hook_fonts
    hook_hyprland
    hook_ly
    hook_waybar
    hook_wayland
    hook_zsh
}

print_pkg_wrap() {
    local -n pkgs_ref=$1
    local maxw=$((COLS - 4))
    local pkg color line="" cur=0 sep="" tok_len

    for pkg in "${pkgs_ref[@]}"; do
        if pkg_installed "$pkg"; then color="$GREEN"; else color="$RED"; missing=$((missing + 1)); fi
        tok_len=$((${#pkg} + ${#sep}))

        if (( cur > 0 && cur + tok_len > maxw )); then
            echo -e "    $line"
            line="" cur=0 sep=""
            tok_len=${#pkg}
        fi

        line+="${sep}${color}${pkg}${NC}"
        cur=$((cur + tok_len))
        sep=", "
    done
    [[ -n "$line" ]] && echo -e "    $line"
}

check_packages() {
    echo -e "${BLUE}Packages${NC}"

    local file cat pkgs pkg total=0 missing=0
    for file in "$PKGS_DIR"/*.txt; do
        [[ -f "$file" ]] || continue
        cat=$(basename "$file" .txt)
        [[ "$IS_WSL" == true && "$cat" != "base" ]] && continue

        pkgs=()
        while IFS= read -r pkg; do pkgs+=("$pkg"); done < <(read_pkgs "$file")
        [[ ${#pkgs[@]} -eq 0 ]] && continue

        total=$((total + ${#pkgs[@]}))
        printf "  %s\n" "${cat^}"
        print_pkg_wrap pkgs
    done

    echo
    echo -e "  ${BLUE}$((total - missing))/${total} installed${NC}"
    echo
}

install() {
    local cat="$1"
    if [[ -z "$cat" ]]; then
        echo -e "${RED}Error: specify a category${NC}"
        echo
        list_categories
        return 1
    fi

    local file="$PKGS_DIR/$cat.txt"
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}Error: unknown category '$cat'${NC}"
        echo
        list_categories
        return 1
    fi

    local pkgs=() pkg
    while IFS= read -r pkg; do pkgs+=("$pkg"); done < <(read_pkgs "$file")

    echo -e "${BLUE}Installing: $cat${NC}"
    if [[ ${#pkgs[@]} -eq 0 ]]; then
        echo -e "${GREEN}Nothing to do${NC}"
        return 0
    fi

    echo -e "${YELLOW}${#pkgs[@]} package(s)${NC}\n"
    sudo pacman -S --needed "${pkgs[@]}"
}

show_help() {
    echo "Usage: dowfiles [COMMAND]"
    echo
    echo "Commands:"
    echo "  check               Check packages + configuration state"
    echo "  install <category>  Install packages from one category"
    echo "  help                Show this message"
    echo
    list_categories
}

clear
echo -ne "${BLUE}Dowfiles Manager${NC} - "
if [[ "$IS_WSL" == true ]]; then
    echo -e "${YELLOW}WSL${NC}\n"
else
    echo -e "${YELLOW}Native${NC}\n"
fi

case "${1:-}" in
    check)
        check_packages
        run_all_hooks
        ;;
    install)
        install "${2:-}" || exit 1
        run_all_hooks
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo -e "${RED}Error: unknown command '$1'${NC}\n"
        show_help
        exit 1
        ;;
esac
