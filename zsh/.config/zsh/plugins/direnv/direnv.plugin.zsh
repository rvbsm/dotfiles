#!/usr/bin/env zsh

if type direnv >/dev/null; then
  eval-tagged "$(direnv --version)" direnv hook zsh
fi
