#!/bin/sh

# Specific player
if [ -n "$1" ]; then
    PLAYER_OPT="-p $1"
else
    PLAYER_OPT=""
fi

while true; do
    artist=$(playerctl $PLAYER_OPT metadata xesam:artist 2>/dev/null)
    title=$(playerctl $PLAYER_OPT metadata xesam:title 2>/dev/null)
    album=$(playerctl $PLAYER_OPT metadata xesam:album 2>/dev/null)

    # Fallbacks
    [ -z "$artist" ] && artist=$(playerctl $PLAYER_OPT metadata artist 2>/dev/null)
    [ -z "$title" ] && title=$(playerctl $PLAYER_OPT metadata title 2>/dev/null)
    [ -z "$album" ] && album=$(playerctl $PLAYER_OPT metadata album 2>/dev/null)

    player_status=$(playerctl $PLAYER_OPT status 2>/dev/null)

    if [ -z "$player_status" ]; then
        echo '{"text": "", "alt": "stopped"}'
        sleep 3
        continue
    fi

    # Cleanup for JSON
    artist=$(echo "$artist" | sed 's/&/&amp;/g')
    title=$(echo "$title" | sed 's/&/&amp;/g')
    album=$(echo "$album" | sed 's/&/&amp;/g')

    if [ -n "$artist" ] && [ -n "$title" ]; then
        text="$artist - $title"
    elif [ -n "$title" ]; then
        text="$title"
    elif [ -n "$album" ]; then
        text="$album"
    else
        text="Unknown"
    fi

    if [ "$player_status" = "Playing" ]; then
        echo '{"text": "'"$text"'", "alt": "playing"}'
    elif [ "$player_status" = "Paused" ]; then
        echo '{"text": "'"$text"'", "class": "paused", "alt": "paused"}'
    else
        echo '{"text": "", "alt": "stopped"}'
    fi

    sleep 3
done
