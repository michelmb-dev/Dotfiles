#!/bin/sh

#---Config
DEFAULT_SINK_INDEX=$(pacmd list-sinks | grep "\* index:" | cut -d' ' -f5)
CUR_VOL=$(pacmd list-sinks | grep -A 15 'index: '"$DEFAULT_SINK_INDEX"'' | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%' | sed s/.$// | tr -d ' ')
MAX_VOL=95


display_volume() {
	if [ -z "$volume" ]; then
	  echo "No Sink"
	else
	  volume="${volume//[[:blank:]]/}" 
	  if [[ "$mute" == *"yes"* ]]; then
	    echo "Off 婢"
	  elif [[ "$mute" == *"no"* ]]; then
	  	if [[ $CUR_VOL -le 25 ]]; then
		  echo "$volume ︁"
		elif [[ $CUR_VOL -le 50 ]]; then
		  echo "$volume "
		elif [[ $CUR_VOL -le 75 ]]; then
		  echo "$volume 墳"  
		else
		  echo "$volume "
		fi
	  else
	    echo "$volume !"
	  fi
	fi
}

case $1 in
	"show-vol")
		if [ -z "$2" ]; then
  			volume=$(pacmd list-sinks | grep "index: $DEFAULT_SINK_INDEX" -A 7 | grep "volume" | awk -F/ '{print $2}')
  			mute=$(pacmd list-sinks | grep "index: $DEFAULT_SINK_INDEX" -A 11 | grep "muted")
			display_volume
            
		else
  			volume=$(pacmd list-sinks | grep "$2" -A 6 | grep "volume" | awk -F/ '{print $2}')
  			mute=$(pacmd list-sinks | grep "$2" -A 11 | grep "muted" )
			display_volume
		fi
		;;
        
	"inc-vol")
		if [ -z "$2" ] && [ "$CUR_VOL" -le "$MAX_VOL" ]; then
			pactl set-sink-volume $DEFAULT_SINK_INDEX +5%
		else
			pactl set-sink-volume $2 +5%
		fi
		;;
	"dec-vol")
		if [ -z "$2" ]; then
			pactl set-sink-volume $DEFAULT_SINK_INDEX -5%
		else
			pactl set-sink-volume $2 -5%
		fi
		;;
	"mute-vol")
		if [ -z "$2" ]; then
			pactl set-sink-mute $DEFAULT_SINK_INDEX toggle
		else
			pactl set-sink-mute $2 toggle
		fi
		;;
	"set-sink")
		if [ -z "$2" ]; then
			pactl set-default-sink $DEFAULT_SINK_INDEX toggle
		else
			pactl set-default-sink $2 toggle
		fi
		;;
	*)
        echo "Invalid script option"
		;;
esac
