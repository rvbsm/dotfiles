#!/usr/bin/env zsh

: "${ZSH_CACHE_DIR:=${XDG_CACHE_HOME:-$HOME/.cache}/zsh}"
mkdir -p "$ZSH_CACHE_DIR"

function eval-tagged {
  local -r tag=$1; shift

  local -r cmd_cache="$ZSH_CACHE_DIR/eval/${*// /_}-${tag// /-}.zsh"
  if [[ ! -s "$cmd_cache" ]]; then
    mkdir -p "${cmd_cache:h}"
    "$@" >|"$cmd_cache"
  fi

  builtin source "$cmd_cache"
}
