#!/usr/bin/env zsh

if eza >/dev/null; then
  alias ls='eza --icons=always'
fi
