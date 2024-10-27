#!/usr/bin/env bash

# Configuration
WALLPAPER_DIR="$HOME/Pictures/wallpapers"  # Change this to your wallpaper directory
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="250"  # Size of thumbnails in pixels (16:9)
THUMBNAIL_HEIGHT="141"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Function to generate thumbnail
generate_thumbnail() {
    local input="$1"
    local output="$2"
    magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_SIZE}" "$output"
}

# Generate thumbnails and create menu items
generate_menu() {
    for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
        # Skip if no matches found
        [[ -f "$img" ]] || continue
        
        # Generate thumbnail filename
        thumbnail="$CACHE_DIR/$(basename "${img%.*}").png"
        
        # Generate thumbnail if it doesn't exist or is older than source
        if [[ ! -f "$thumbnail" ]] || [[ "$img" -nt "$thumbnail" ]]; then
            generate_thumbnail "$img" "$thumbnail"
        fi
        
        # Output menu item (filename and path)
        echo -en "img:$thumbnail\x00info:$(basename "$img")\x1f$img\n"
    done
}

# Use wofi to display grid of wallpapers
selected=$(generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --define "image-size=$THUMBNAIL_SIZE" \
    --columns 4 \
    --allow-images \
    --insensitive \
    --prompt "Select Wallpaper" \
    --conf ~/.config/wofi/wallpaper.conf \
  )

# Set wallpaper if one was selected
if [ -n "$selected" ]; then
    # Remove the img: prefix to get the cached thumbnail path
    thumbnail_path="${selected#img:}"
    
    # Get the original filename from the thumbnail path
    original_filename=$(basename "${thumbnail_path%.*}")
    
    # Find the corresponding original file in the wallpaper directory
    original_path=$(find "$WALLPAPER_DIR" -type f -name "${original_filename}.*" | head -n1)
    
    # Set wallpaper using swww with the original file
    swww img "$original_path" --transition-type grow --transition-fps 160 --transition-duration 1 --transition-bezier 0.65,0,0.35,1 --transition-step 1
    
    # Save the selection for persistence
    echo "$original_path" > "$HOME/.cache/current_wallpaper"
    
    # Optional: Notify user
    notify-send "Wallpaper" "Wallpaper has been updated" -i "$original_path"
fi
