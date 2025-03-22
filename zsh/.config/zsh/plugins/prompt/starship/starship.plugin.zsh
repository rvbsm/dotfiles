#!/usr/bin/env zsh

if type starship >/dev/null; then
  eval-tagged "$(starship -V)" starship init zsh
fi
