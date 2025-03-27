#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
for i in "${!SPACE_ICONS[@]}"
do
  sid=$((i + 1))

  space=(
    associated_space=$sid
    icon="${SPACE_ICONS[$i]}"
    icon.padding_left=10
    icon.padding_right=10
    padding_left=2
    padding_right=2
    label.padding_right=10
    icon.highlight_color=$RED
    label.color=$GREY
    label.highlight_color=$WHITE
    label.font="sketchybar-app-font:Regular:16.0"
    label.y_offset=-1
    background.color=$BACKGROUND_1
    background.drawing=off
    label.drawing=off
    script="$PLUGIN_DIR/space.sh"
  )

  # Conditionally update background color if SELECTED is set
  if [ -n "$SELECTED" ]; then
    space+=(background.color=0xffffffff)
  fi

  sketchybar --add space space.$sid left    \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked
done
