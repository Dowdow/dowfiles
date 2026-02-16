#!/bin/bash

cmd="$1"

if [ -z "$cmd" ]; then
    exit 1
fi

if [[ "$cmd" == *"-right" ]]; then
    monitor_cmd="focus-monitor-right"
elif [[ "$cmd" == *"-left" ]]; then
    monitor_cmd="focus-monitor-left"
else
    exit 1
fi

before=$(niri msg -j focused-window | jq '.id')

niri msg action "$cmd"

after=$(niri msg -j focused-window | jq '.id')

if [ "$before" = "$after" ]; then
    niri msg action "$monitor_cmd"
fi
