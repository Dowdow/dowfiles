#!/bin/sh

entries="\tLock\n\tLogout\n\tSuspend\n\tReboot\n\tPoweroff"

chosen=$(echo -e "$entries" | wofi --dmenu --prompt "Power Menu :")

case "$chosen" in
    *Poweroff) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
    *Suspend) systemctl suspend ;;
    *Lock) hyprlock ;;  # ou swaylock, selon ce que tu utilises
    *Logout) hyprctl dispatch exit ;;
    *) exit 1 ;;
esac
