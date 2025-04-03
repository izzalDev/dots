#!/bin/bash
source "$CONFIG_DIR/plugins/icon_map.sh"

if [ "$SENDER" != "space_windows_change" ]; then
    exit 0
fi

space=$(echo "$INFO" | jq -r '.space')
apps=$(echo "$INFO" | jq -r '.apps | keys[]')

# Process app icons
if [ -n "$apps" ]; then
    icon_strip=" "
    while read -r app; do
        icon_strip+=" $(icon_map "$app")"
    done <<< "$apps"
    padding=20
else
    icon_strip="-"
    padding=10
fi

sketchybar --animate sin 10 \
  --set "space.$space" \
    label="$icon_strip" \
    label.font="sketchybar-app-font:Regular:13" \
    label.padding_right="$padding"
