#!/usr/bin/env bash
set -e

SAVE_DIR="$HOME/Screenshots"
mkdir -p "$SAVE_DIR"

FILE="$SAVE_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"

MODE="$1" # fullscreen | area | window
SAVE="$2"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "📸 Screenshot" "$1"
    fi
}

case "$MODE" in
    fullscreen)
        grim "$FILE"
        ;;
    area)
        GEOM=$(slurp -d)
        [ -z "$GEOM" ] && exit 0
        grim -g "$GEOM" "$FILE"
        ;;
    window)
        read -r X Y W H < <(
            hyprctl activewindow -j | jq -r '[.at[0], .at[1], .size[0], .size[1]] | @tsv'
        )
        echo "$X $Y $W $H"
        [ -z "$X" ] && notify "Impossible to find active window" && exit 1
        grim -g "${X},${Y} ${W}x${H}" "$FILE"
        ;;
    *)
        notify "Unknown mode : $MODE"
        exit 1
        ;;
esac

if command -v wl-copy >/dev/null 2>&1; then
    wl-copy < "$FILE"
else
    notify "wl-copy missing"
fi

if [ "$SAVE" != "save" ]; then
    rm "$FILE"
    notify "Screenshot saved to clipboard"
else
    notify "Screenshot copied and saved to $FILE"
fi
