#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/wallpapers"

# Get all monitor names
MONITORS=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
hyprctl hyprpaper preload "$WALLPAPER"

for MON in $MONITORS; do
    hyprctl hyprpaper wallpaper "$MON,$WALLPAPER"
done
