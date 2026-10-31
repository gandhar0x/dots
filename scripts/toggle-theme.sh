#!/usr/bin/env bash

STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/current_theme"
FOOT_INI="${XDG_CONFIG_HOME:-$HOME/.config}/foot/foot.ini"

# Initialize state file to dark if missing
if [ ! -f "$STATE_FILE" ]; then
    echo "dark" > "$STATE_FILE"
fi

CURRENT_THEME=$(cat "$STATE_FILE")

if [ "$CURRENT_THEME" = "dark" ]; then
    NEXT_THEME="light"

    # 1. Foot: Send SIGUSR2 to switch to [colors-light]
    killall -SIGUSR2 foot 2>/dev/null
    killall -SIGUSR2 footclient 2>/dev/null

    # Update initial-color-theme in foot.ini for newly launched terminals
    if [ -f "$FOOT_INI" ]; then
        sed -i 's/^initial-color-theme=.*/initial-color-theme=light/' "$FOOT_INI"
    fi

    # 2. Sway: Rosé Pine Dawn window borders
    # client.<class> <border> <background> <text> <indicator> <child_border>
    swaymsg client.focused          "#907aa9 #faf4ed #575279 #286983 #907aa9"
    swaymsg client.focused_inactive "#dfdad9 #faf4ed #797593 #dfdad9 #dfdad9"
    swaymsg client.unfocused        "#f2e9de #faf4ed #9893a5 #f2e9de #f2e9de"
    swaymsg client.urgent           "#b4637a #b4637a #faf4ed #b4637a #b4637a"

    echo "light" > "$STATE_FILE"

else
    NEXT_THEME="dark"

    # 1. Foot: Send SIGUSR1 to switch to [colors-dark]
    killall -SIGUSR1 foot 2>/dev/null
    killall -SIGUSR1 footclient 2>/dev/null

    # Update initial-color-theme in foot.ini for newly launched terminals
    if [ -f "$FOOT_INI" ]; then
        sed -i 's/^initial-color-theme=.*/initial-color-theme=dark/' "$FOOT_INI"
    fi

    # 2. Sway: Rosé Pine Dark window borders
    swaymsg client.focused          "#c4a7e7 #191724 #e0def4 #31748f #c4a7e7"
    swaymsg client.focused_inactive "#26233a #191724 #908caa #26233a #26233a"
    swaymsg client.unfocused        "#1f1d2e #191724 #6e6a86 #1f1d2e #1f1d2e"
    swaymsg client.urgent           "#eb6f92 #eb6f92 #e0def4 #eb6f92 #eb6f92"

    echo "dark" > "$STATE_FILE"
fi
