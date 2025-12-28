#!/bin/bash

# 1. Get the address of the Brave window
BRAVE_ADDR=$(hyprctl clients -j | jq -r '.[] | select(.class == "brave-browser") | .address')

# 2. If Brave isn't running, launch it and exit
if [ -z "$BRAVE_ADDR" ]; then
    brave --ozone-platform-hint=auto --password-store=basic --restore-last-session &
    exit 0
fi

# 3. Get the current active workspace ID
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# 4. Get Brave's current workspace ID
BRAVE_WS=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$BRAVE_ADDR\") | .workspace.id")

# 5. Toggle logic
if [ "$CURRENT_WS" == "$BRAVE_WS" ]; then
    # If Brave is here, send it to workspace 9
    hyprctl dispatch movetoworkspacesilent 9,address:$BRAVE_ADDR
else
    # If Brave is elsewhere, bring it to the current workspace
    hyprctl dispatch movetoworkspace $CURRENT_WS,address:$BRAVE_ADDR
    # Focus the window so it's ready to use
    hyprctl dispatch focuswindow address:$BRAVE_ADDR
fi
