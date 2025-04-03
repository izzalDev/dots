#!/bin/bash

function update {
  free_percentage=$(memory_pressure | \
    grep "System-wide" | \
    awk '{ print $5 }' | \
    tr -d '%')

  used_percentage=$((100 - free_percentage))

  used_gb=$(echo "scale=2; $used_percentage * 8 / 100" | bc)

  sketchybar --set $NAME icon="${used_gb} GB"
}

function click {
  osascript -e '
  tell application "System Events"
	  set apps to processes whose background only is false
	  repeat with anApp in apps
		  set appName to name of anApp
		  set windowCount to count of window of anApp
		  if windowCount is 0 and appName is not "Finder" then
			  do shell script "killall " & quoted form of appName
		  end if
	  end repeat
  end tell'
}

case "$SENDER" in
  "routine") update
  ;;
  "mouse.clicked") click
  ;;
esac

