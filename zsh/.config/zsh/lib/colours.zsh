#!/usr/bin/env zsh

export THEME='catppuccin'
export THEME_FLAVOUR='mocha'

if type darkman >/dev/null; then
  case "$(command darkman get)" in
    light) THEME_FLAVOUR='latte'
    ;;
    dark|*) THEME_FLAVOUR='mocha'
    ;;
  esac
fi

if type vivid >/dev/null; then
  export LS_COLORS="$(command vivid generate "$THEME-$THEME_FLAVOUR")"
fi

if type bat >/dev/null; then
  export BAT_THEME="${(C)THEME} ${(C)THEME_FLAVOUR}"
fi
