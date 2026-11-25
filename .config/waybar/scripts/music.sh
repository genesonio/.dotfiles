#!/usr/bin/env bash
icon=$''
frames=("▁▃▅▃" "▃▅▇▅" "▅▇▅▃" "▇▅▃▁" "▅▃▁▃" "▃▁▃▅")
i=0

while true; do
  if [ "$(playerctl status 2>/dev/null)" = "Playing" ]; then
    printf '{"text": "%s %s", "class": "playing"}\n' "$icon" "${frames[i]}"
    i=$(((i + 1) % ${#frames[@]}))
    sleep 0.3
  else
    printf '{"text": "%s", "class": "paused"}\n' "$icon"
    sleep 1
  fi
done
