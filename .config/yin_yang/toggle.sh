#!/usr/bin/sh

THEME_VARIANT="${THEME_VARIANT:?}"

# Alacritty
ALACRITTY_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"
sed -i "s#^import = .*#import = ['$ALACRITTY_HOME/catppuccin_$THEME_VARIANT.toml']#" "$ALACRITTY_HOME/alacritty.toml"

# Bat
sed -i "s#--theme=.*#--theme='Catppuccin ${THEME_VARIANT^}'#" "$(bat --config-file)"

