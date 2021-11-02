#!/bin/sh

#---Config
DEFAULT_SOURCE_INDEX=$(pacmd list-sources | grep "\* index:" | cut -d' ' -f5)
CUR_VOL=$(pacmd list-sources | grep -A 15 'index: '"$DEFAULT_SOURCE_INDEX"'' | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%' | sed s/.$// | tr -d ' ')
MAX_VOL=95


display_volume() {
	if [ -z "$volume" ]; then
	  echo "No Mic"
	else
	  volume="${volume//[[:blank:]]/}" 
	  if [[ "$mute" == *"yes"* ]]; then
	    echo "Off "
	  elif [[ "$mute" == *"no"* ]]; then
	    echo "$volume "
	  else
	    echo "$volume !"
	  fi
	fi
}

case $1 in
	"show-vol")
		if [ -z "$2" ]; then
  			volume=$(pacmd list-sources | grep "index: $DEFAULT_SOURCE_INDEX" -A 7 | grep "volume" | awk -F/ '{print $2}')
  			mute=$(pacmd list-sources | grep "index: $DEFAULT_SOURCE_INDEX" -A 11 | grep "muted")
			display_volume
            
		else
  			volume=$(pacmd list-sources | grep "$2" -A 6 | grep "volume" | awk -F/ '{print $2}')
  			mute=$(pacmd list-sources | grep "$2" -A 11 | grep "muted" )
			display_volume
		fi
		;;
        
	"inc-vol")
		if [ -z "$2" ] && [ "$CUR_VOL" -le "$MAX_VOL" ]; then
			pactl set-source-volume $DEFAULT_SOURCE_INDEX +5%
		else
			pactl set-source-volume $2 +5%
		fi
		;;
	"dec-vol")
		if [ -z "$2" ]; then
			pactl set-source-volume $DEFAULT_SOURCE_INDEX -5%
		else
			pactl set-source-volume $2 -5%
		fi
		;;
	"mute-vol")
		if [ -z "$2" ]; then
			pactl set-source-mute $DEFAULT_SOURCE_INDEX toggle
		else
			pactl set-source-mute $2 toggle
		fi
		;;
	*)
        echo "Invalid script option"
		;;
esac
