#!/usr/bin/env zsh

[[ "$ZPROF" -ne 0 ]] && zmodload zsh/zprof

setopt notify

function load_antidote {
  builtin unset -f load_antidote

  local -r antidote_home="${XDG_CACHE_HOME:-$HOME/.cache}"/.antidote
  if [ ! -d "$antidote_home" ]; then
    git clone --depth=1 git@github.com:mattmc3/antidote.git "$antidote_home"
  fi

  local -r zshplugins="$ZDOTDIR"/.zshplugins
  local -r zshplugins_bundle="${XDG_CACHE_HOME:-$HOME/.cache}"/zsh/zshplugins.zsh

  if [[ ! "$zshplugins_bundle" -nt "$zshplugins" ]]; then
    builtin source "$antidote_home"/antidote.zsh
    antidote bundle <"$zshplugins" >|"$zshplugins_bundle"
    unfunction antidote
  fi

  builtin source "$zshplugins_bundle"
}

load_antidote "$@"

[[ "$ZPROF" -ne 0 ]] && zprof
