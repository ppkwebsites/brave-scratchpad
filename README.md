# brave-scratchpad
Brave scratchpad on Hyprland

Hyprland Tiling Scratchpad (No Floating)
This repository contains the configuration and scripts shown in my tutorial on how to create a "scratchpad" effect in Hyprland that tiles with your existing windows instead of floating on top of them.

📖 The Problem vs. The Solution
Standard Hyprland scratchpads use special workspaces, which are designed to float by default. If you prefer a tiled workflow (especially on smaller screens or using plugins like Hyprscrolling), you might want your "scratchpad" app to:

Tile automatically when called [02:20].

Hide to a background workspace when sent away [03:07].

Remember its state so it doesn't have to reload every time.

🚀 How it Works
Since Hyprland doesn't have a native "toggle workspace" command for normal workspaces, this setup uses a custom Bash script to:

Check if the application (e.g., Brave Browser) is already running [05:45].

Detect the current active workspace.

Toggle the application between the active workspace and a "hidden" workspace (Workspace 9) [06:57].

🛠️ Installation
1. The Toggle Script
Save the following script as toggle_brave.sh in your ~/.config/hypr/scripts/ directory.

Bash

#!/bin/bash
# Script to toggle Brave between workspace 9 and current workspace

if ! pgrep -x "brave" > /dev/null; then
    brave & 
    exit
fi

active_workspace=$(hyprctl activeworkspace -j | jq '.id')
brave_workspace=$(hyprctl clients -j | jq '.[] | select(.class == "brave-browser") | .workspace.id')

if [ "$active_workspace" == "$brave_workspace" ]; then
    hyprctl dispatch movetoworkspace silent 9,class:brave-browser
else
    hyprctl dispatch movetoworkspace current,class:brave-browser
    hyprctl dispatch focuswindow class:brave-browser
fi
2. Hyprland Keybind
Add this to your hyprland.conf:

Ini, TOML

bind = $mainMod, B, exec, ~/.config/hypr/scripts/toggle_brave.sh
📦 Dependencies
jq: Used for parsing Hyprland's JSON output in the script.

brave-browser: The example app used in the video (can be swapped for any app).

📺 References
Hyprscrolling: Used in the video to manage tiled windows in columns [02:42].

Yazi: The terminal file manager used to showcase the script [04:52].


my-wofi-theme/
├── README.md          (Instructions and screenshots)
├── install.sh         (Optional: A script to copy files for the user)
└── .config/
    └── wofi/
        ├── config     (Wofi configuration)
        ├── style.css  (Your CSS theme)
        └── menu.sh    (Your custom script)
