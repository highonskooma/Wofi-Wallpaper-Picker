# Wofi Wallpaper Picker

This Wofi widget allows for previewing multiple wallpapers and choosing one to be set. The wallpapers are set using swww.

![alt text](assets/screenshot.png "Wofi Wallpaper Picker")

### Dependencies
This script uses `magick` and `swww`, and of course, `wofi`. Make use you have them installed.
`notify-send` is an optional dependency.
Also, this might only work on Wayland.

### Installation

1. Clone the repo
2. Copy `wofi/wallpaper.conf` and `wofi/style.css` to `~/.config/wofi/`
3. Make the script executable
```$ chmod +x wofi-wallpaper-selector.sh```
4. Run the script

### Usage
You can set this widget to an alias on your shell, or add it to a module on waybar, your choice really.

### Special Thanks
Claude :)
