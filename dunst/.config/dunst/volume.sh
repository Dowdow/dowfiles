#!/bin/bash

case "$1" in
    up)   wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0 ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac

VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "yes" || echo "no")

if [ "$MUTED" = "yes" ]; then
    notify-send \
        -h string:x-dunst-stack-tag:vol \
        -h string:category:volume \
        -h int:value:0 \
        "Mute"
else
    notify-send \
        -h string:x-dunst-stack-tag:vol \
        -h string:category:volume \
        -h int:value:"$VOLUME" \
        "Volume $VOLUME%"
fi
