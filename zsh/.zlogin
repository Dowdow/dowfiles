if command -v start-hyprland >/dev/null 2>&1 && [[ "$(tty)" == "/dev/tty1" ]]; then
    start-hyprland
fi
