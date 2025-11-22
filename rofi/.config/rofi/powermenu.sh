#!/bin/sh

entries=" Lock
 Logout
 Suspend
 Reboot
 Poweroff"

chosen=$(echo "$entries" | rofi -dmenu -i -p "Power Menu :")

case "$chosen" in
    *Poweroff) systemctl poweroff ;;
    *Reboot) systemctl reboot ;;
    *Suspend) systemctl suspend ;;
    *Lock) hyprlock ;;
    *Logout) hyprctl dispatch exit ;;
    *) exit 1 ;;
esac
