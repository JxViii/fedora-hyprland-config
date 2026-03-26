#!/usr/bin/env bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Light / Purple theme switcher

# ===================== PATHS =====================

PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")"
WALLPAPER_BASE="$PICTURES_DIR/wallpapers"
PURPLE_WALLPAPER="$WALLPAPER_BASE/wenjun-lin-purple-blue.jpg"
LIGHT_WALLPAPER="$WALLPAPER_BASE/wenjun-lin-red.jpg"

SCRIPTSDIR="$HOME/.config/hypr/scripts"
THEME_CACHE="$HOME/.cache/.theme_mode"
NOTIF_ICON="$HOME/.config/swaync/images/bell.png"

WAYBAR_STYLES="$HOME/.config/waybar/style"
WAYBAR_STYLE_LINK="$HOME/.config/waybar/style.css"

KITTY_THEMES="$HOME/.config/kitty/kitty-themes"
KITTY_THEME_LINK="$HOME/.config/kitty/kitty-themes/current-theme.conf"

# ===================== SWWW SETUP =====================

swww query || swww-daemon --format xrgb
SWWW_OPTS="--transition-bezier .43,1.19,1,.4 --transition-fps 60 --transition-type grow --transition-pos 0.925,0.977 --transition-duration 2"

# ===================== DETERMINE NEXT MODE =====================

current_mode="$(cat "$THEME_CACHE" 2>/dev/null || echo "Light")"

if [ "$current_mode" = "Light" ]; then
    next_mode="Purple"
    next_wallpaper="$PURPLE_WALLPAPER"
else
    next_mode="Light"
    next_wallpaper="$LIGHT_WALLPAPER"
fi

# ===================== FUNCTIONS =====================

update_theme_mode() {
    echo "$next_mode" > "$THEME_CACHE"
}

notify_user() {
    notify-send -u low -i "$NOTIF_ICON" " Switching to" " $1 mode"
}

set_waybar_style() {
    local theme="$1"
    local style_prefix="\\[JxViii\\] ${theme}.*\\.css$"
    local style_file
    style_file=$(find -L "$WAYBAR_STYLES" -maxdepth 1 -type f -regex ".*$style_prefix" | shuf -n 1)

    if [ -n "$style_file" ]; then
        ln -sf "$style_file" "$WAYBAR_STYLE_LINK"
    else
        echo "Style file not found for $theme theme."
    fi
}

set_kitty_theme() {
    local theme="$1"
    local theme_file

    if [ "$theme" = "Purple" ]; then
        theme_file="$KITTY_THEMES/[JxViii] Purple-Blue.conf"
    else
        theme_file="$KITTY_THEMES/[JxViii] Light-Yellow.conf"
    fi

    if [ -f "$theme_file" ]; then
        ln -sf "$theme_file" "$KITTY_THEME_LINK"
        # Reload all running kitty instances
        for pid in $(pidof kitty); do
            kill -SIGUSR1 "$pid" 2>/dev/null
        done
    else
        echo "Kitty theme not found: $theme_file"
    fi
}

kill_processes() {
    for proc in waybar rofi swaync ags swaybg; do
        killall "$proc" 2>/dev/null
    done
}

# ===================== EXECUTE =====================

set_waybar_style "$next_mode"
update_theme_mode
notify_user "$next_mode"

# Set wallpaper
swww img "$next_wallpaper" $SWWW_OPTS
"${SCRIPTSDIR}/WallustSwww.sh"

# Restart UI
kill_processes
sleep 2
set_kitty_theme "$next_mode"
"${SCRIPTSDIR}/Refresh.sh"
sleep 0.5

notify-send -u low -i "$NOTIF_ICON" " Themes switched to:" " $next_mode Mode"