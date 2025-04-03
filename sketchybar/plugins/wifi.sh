#!/bin/bash

function update {
  source "icons.sh"
  ICON="$([ -n "$(ipconfig getifaddr en0)" ] && echo "$WIFI_CONNECTED" || echo "$WIFI_DISCONNECTED")"
  sketchybar --set $NAME icon="$ICON"
}

function click {
  open "x-apple.systempreferences:com.apple.preference.network?Wi-Fi"
}

case "$SENDER" in
  "wifi_change") update
  ;;
  "mouse.clicked") click
  ;;
esac
