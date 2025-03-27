#!/bin/bash

calendar=(
  icon.font="$FONT:Bold:12.0"
  icon.padding_right=0
  label.align=right
  padding_left=15
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke
