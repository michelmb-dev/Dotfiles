#!/usr/bin/env bash

dir="~/.config/polybar/scripts/rofi"

rofi_command="rofi -theme $dir/powermenu.rasi"

# Options
shutdown="  Éteindre"
reboot="  Redémarrer"
lock="  Vérrouiller"
suspend="  Mise En Veille"
logout="  Quitter La Session"


# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		systemctl poweroff
        ;;
    $reboot)
		systemctl reboot
        ;;
    $lock)
		if [[ -f /usr/bin/dm-tool ]]; then
			dm-tool lock
			systemctl supend
		elif [[ -f /usr/bin/i3lock ]]; then
			i3lock
		fi
        ;;
    $suspend)
		systemctl suspend
        ;;
	$logout)
		if [[ -f /usr/bin/i3 ]]; then
			i3-msg exit
		fi
        ;;
esac
