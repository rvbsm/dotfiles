# ZSH config
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt rematchpcre

# Environment variables
CODE_HOME="$HOME/Code"

PATH="$PATH:$HOME/.local/bin"

if type cargo >/dev/null; then
  CARGO_HOME="$HOME/.cargo"
  PATH="$PATH:$CARGO_HOME/bin"
fi

if type pnpm >/dev/null; then
  PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
  PATH="$PATH:$PNPM_HOME"
fi

if type go >/dev/null; then
  GOPATH="$HOME/.go"
  PATH="$PATH:$GOPATH/bin"
fi

BUN_INSTALL="$HOME/.bun"
if [[ -d "$BUN_INSTALL" ]]; then
  PATH="$PATH:$BUN_INSTALL/bin"
fi

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  git clone git@github.com:zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

zinit ice as'command' from'gh-r' \
	  atclone'./starship init zsh > init.zsh; ./starship completions zsh > _starship' \
	  atpull'%atclone' src'init.zsh'
zinit light starship/starship

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::sudo
zinit snippet OMZP::rust

autoload -U compinit && compinit

zinit cdreplay -q

# Completions
zstyle ':completion:*:git-checkout:*' sort false
# zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

# Bindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Evals
eval "$(zoxide init --cmd cd zsh)"
eval "$(direnv hook zsh)"

# Aliases
if type eza > /dev/null; then
  alias ls='eza --icons=always'
fi

alias ll='ls -lh'
alias lla='ll -a'
alias llg='ll -g'
alias tree='ls -T'

if type bat >/dev/null; then
  alias cat='bat -pp'
  alias less='bat'
fi

if type dust >/dev/null; then
  alias du='dust'
fi

# Util functions
gtr::clone() {
  if [[ ! -d "$CODE_HOME" ]]; then
    >&2 echo '$CODE_HOME is not a directory'
    return 2
  fi

  declare host='github.com'
  declare user=$(whoami)
  declare -r repo=$(basename "$1" '.git')
  if [[ -z "$repo" ]]; then
    >&2 echo 'What the heck is that repo?'
    return 2
  fi

  declare repo_path="$repo"
  if [[ "$1" =~ '(?:^(?:git@|https?://)?([\w\.@]+)[/:])?(?:([\w,\-,\_]+)/)([\w,\-,\_]+)(?:\.git)?/?$' ]]; then
    host="${match[1]:-$host}"
    user="${match[2]}"

    if [[ "$(whoami)" != "$user" ]]; then
      repo_path="$host/$user/$repo"
    fi
  fi

  if [[ ! -d "$CODE_HOME/$repo_path" ]]; then
    if read -q "read_response?Clone $repo_path? [y/N]: "; then
      mkdir -p "$CODE_HOME/$repo_path"

      >&2 echo; shift; git clone $@ "git@$host:$user/$repo.git" "$CODE_HOME/$repo_path"
    else
      >&2 echo; return 1
    fi
  fi

  echo "$CODE_HOME/$repo_path"
}
alias grc='gtr::clone'

gtr::cd() {
  declare repo_path
  repo_path=$(gtr::clone $@) || return $?
  
  if [[ -d "$repo_path" ]]; then
    cd -- "$repo_path"
  fi
}
alias grd='gtr::cd'

gtr::list() {
  local project_path="$(
    find "$CODE_HOME" -maxdepth 3 \
      -not -path '*/.*' \
      -type d \
      -exec [ -e '{}/.git' ] ';' \
      -prune -printf '%T+\t%p\t%P\n' |
    sort -r |
    fzf --delimiter '\t' --with-nth 3 --no-multi \
    --preview '
      [ -f {2}/README.md ] && \
        glow --style notty {2}/README.md || \
        eza --all --oneline --classify --icons=always --colour=always {2}
    ' |
    cut -f 2
  )"

  gtr::cd "$project_path"
}
alias grl='gtr::list'
