#!/usr/bin/sh

case "${1:?}" in
  light)
    FLAVOUR=latte
    ;;

  dark)
    FLAVOUR=mocha
    ;;

  *)
    echo "Unknown variant. Possible variants: light, dark"
    exit 1
    ;;
esac

function replace_theme {
  local config_path="$1"
  local target="$2"
  local delimeter="$3"
  local replacement="$4"

  if [ ! -f "$config_path" ]; then
    return 1
  fi

  sed -i "/^$target$delimeter/{h;s#$delimeter.*#$delimeter$replacement#};\${x;/^$/{s##$target$delimeter$replacement#;H};x}" "$config_path"
}

# Alacritty
ALACRITTY_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"
replace_theme "$ALACRITTY_HOME/alacritty.toml" 'import' ' = ' "['$ALACRITTY_HOME/catppuccin_$FLAVOUR.toml']"

# Bat
if type bat > /dev/null; then
  replace_theme "$(bat --config-file)" '--theme' '=' "'Catppuccin ${FLAVOUR^}'"
fi
