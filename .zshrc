# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment variables
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
CODE_HOME=$HOME/Code
export GEODE_SDK="$HOME/Documents/Geode"

if type cargo > /dev/null; then
  CARGO_HOME="$HOME/.cargo"
  PATH="$PATH:$CARGO_HOME/bin"
fi

if type pnpm > /dev/null; then
  PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
  PATH="$PATH:$PNPM_HOME"
fi

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

# Zinit
if [ ! -d "$ZINIT_HOME" ]; then
  git clone git@github.com:zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # edit: p10k configure

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::sudo
zinit snippet OMZP::rust

autoload -U compinit && compinit

zinit cdreplay -q

# Completions
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
# zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
# zstyle ":completion:*" menu no
# zstyle ":fzf-tab:complete:cd:*" fzf-preview  "ls --color $realpath"
# zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview "ls --color $realpath"

# Bindings
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Evals
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(gix completions -s zsh)"

# Aliases
if type exa > /dev/null; then
  alias ls="eza --icons=always"
fi

alias ll="ls -lh"
alias lla="ll -a"
alias llg="ll -g"
alias tree="ls -T"

if type bat > /dev/null; then
  alias cat="bat -pp"
  alias less="bat"
fi

if type dust > /dev/null; then
  alias du="dust"
fi

if type yt-dlp > /dev/null; then
  alias yt="yt-dlp --downloader aria2c --downloader-args '-c -j 3 -x 3 -s 3 -k 1M' --proxy 127.0.0.1:8085 --embed-metadata --embed-thumbnail --embed-chapters"
  alias ytm="yt -f ba[ext=m4a] --ppa 'ThumbnailsConvertor+ffmpeg_o:-c:v png -vf crop=\"ih\"'"
fi

alias gc="__git_clone_repo"
alias gcd="__git_clone_and_change_dir"

# Util functions
__git_clone_repo() {
  local git_repo_re="(?:^(?:git@|https?://)?([\w\.@]+)[/:])?([\w,\-,\_]+)/([\w,\-,\_]+)(?:\.git){0,1}/{0,1}$"

  if [[ $1 =~ $git_repo_re ]]; then
    local host="${match[1]:-github.com}"
    local user="${match[2]}"
    local repo="${match[3]}"

    if [[ ! -d "$CODE_HOME" ]]; then
      >&2 echo "\$CODE_HOME is not a directory"
      return 1
    fi

    local repo_url="git@$host:$user/$repo.git"
    local repo_path="$CODE_HOME/$host/$user/$repo"
    if [[ -d "$repo_path" ]]; then
      printf "%s" "$repo_path"
      return 1
    fi
    
    mkdir -p "$repo_path"

    >&2 printf "Cloning %s/%s into %s...\n" "$user" "$repo" "$repo_path"

    shift
    gix clone $@ "$repo_url" "$repo_path"
    printf "%s" "$repo_path"
  else
    >&2 echo "Format: git clone <repository> [args]"
  fi
}

__git_clone_and_change_dir() {
  local repo_path=$(gc $@)
  
  if [[ -d "$repo_path" ]]; then
    cd "$repo_path"
  fi
}

