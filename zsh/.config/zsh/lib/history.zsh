setopt appendhistory
setopt sharehistory
setopt histignorespace
setopt histignoredups
setopt histignorealldups
setopt histsavenodups
setopt histfindnodups
setopt rematchpcre

export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}"/zsh/history
export SAVEHIST=50000
export HISTSIZE=10000
export HISTDUP=erase
