#!/usr/bin/env zsh

if type zoxide >/dev/null; then
  eval-tagged "$(zoxide -V)" zoxide init --cmd cd zsh
fi
