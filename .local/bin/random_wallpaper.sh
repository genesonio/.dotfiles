#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers"
INTERVAL=120

# Get all monitor names
MONITORS=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

while true; do
    # Pick random wallpaper
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -path "*/.git/*" | shuf -n 1)

    # Preload image
    hyprctl hyprpaper preload "$WALLPAPER"

    # Apply to all monitors
    for MON in $MONITORS; do
        hyprctl hyprpaper wallpaper "$MON,$WALLPAPER"
    done

    sleep "$INTERVAL"
done
