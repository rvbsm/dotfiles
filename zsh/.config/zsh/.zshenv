#!/usr/bin/env zsh

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_BIN_HOME="$HOME"/.local/bin
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

export XDG_PROJECTS_DIR="$HOME"/Code
export XDG_DESKTOP_DIR="$HOME"/Desktop
export XDG_DOCUMENTS_DIR="$HOME"/Documents
export XDG_DOWNLOADS_DIR="$HOME"/Downloads
export XDG_MUSIC_DIR="$HOME"/Music
export XDG_PICTURES_DIR="$HOME"/Pictures
export XDG_PUBLICSHARE_DIR="$HOME"/Public
export XDG_TEMPLATES_DIR="$HOME"/Templates
export XDG_VIDEOS_DIR="$HOME"/Videos

typeset -gU path fpath

path+="$XDG_BIN_HOME"

export WAKATIME_HOME="$XDG_CONFIG_HOME"/wakatime
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

# export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export WINEPREFIX="$XDG_DATA_HOME"/wine

export GOPATH="$XDG_DATA_HOME"/go
path+="$GOPATH"/bin

if type cargo >/dev/null; then
  export CARGO_HOME="$XDG_DATA_HOME"/cargo
  path+="$CARGO_HOME"/bin
fi

if type java >/dev/null; then
  export _JAVA_OPTIONS="-Djava.util.prefs.userRoot='$XDG_CONFIG_HOME/java'"
  export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

  if type idea >/dev/null && [[ -d '/usr/lib/jvm/jre-jetbrains' ]]; then
    export IDEA_JDK='/usr/lib/jvm/jre-jetbrains'
  fi
fi

