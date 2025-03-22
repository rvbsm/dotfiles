#!/usr/bin/env zsh

setopt completeinword
setopt alwaystoend
setopt noglobdots
setopt caseglob

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME"/zcompcache

zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:git-checkout:*' sort false

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
