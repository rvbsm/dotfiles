#!/usr/bin/env zsh

function gtr::clone {
  if [[ ! -d "$XDG_PROJECTS_DIR" ]]; then
    >&2 echo '$XDG_PROJECTS_DIR is not a directory'
    return 2
  fi

  local -r repo_url="${@[$#]}"

  local host='github.com'
  local user="$(whoami)"
  local -r repo="$(basename "$repo_url" '.git')"
  if [[ -z "$repo" ]]; then
    >&2 echo 'No repository was specified'
    return 2
  fi

  local repo_path="$repo"
  if [[ "$repo_url" =~ '(?:^(?:git@|https?://)?([\w\.@]+)[/:])?(?:([\w,\-,\_]+)/)([\w,\-,\_]+)(?:\.git)?/?$' ]]; then
    host="${match[1]:-$host}"

    if [[ "${match[2]}" != "$user" ]]; then
      user="${match[2]}"
      repo_path="$host/$user/$repo"
    fi
  fi

  local -a argv=(${@:1:$# - 1})

  local -r clone_path="$XDG_PROJECTS_DIR/$repo_path"
  if [[ ! -d "$clone_path" ]]; then
    if read -q "read_response?git clone ${argv[@]} git@$host:$user/$repo.git [y/N]: "; then
      mkdir -p "$clone_path"
      >&2 echo
      command git clone "${argv[@]}" "git@$host:$user/$repo.git" "$clone_path"
    else
      >&2 echo
      return 1
    fi
  fi

  echo "$clone_path"
}

function gtr::cd {
  local repo_path
  repo_path=$(gtr::clone "$@") || return $?
  
  if [[ -d "$repo_path" ]]; then
    cd -- "$repo_path"
  fi
}

function gtr::list {
  local project_path="$(
    find "$XDG_PROJECTS_DIR" -maxdepth 3 \
      -not -path '*/.*' \
      -type d \
      -exec [ -e '{}/.git' ] ';' \
      -prune -printf '%T+\t%p\t%P\n' |
    sort -r |
    fzf --delimiter '\t' --with-nth 3 --no-multi \
    --preview '
      [ -f {2}/README.md ] && \
        glow {2}/README.md || \
        eza --all --oneline --classify --icons=always --colour=always {2}
    ' |
    cut -f 2
  )"

  gtr::cd "$project_path"
}

function gtr {
  if [[ $# -eq 0 ]]; then
    echo "Help"
    return 0
  fi

  local -r cmd="$1"; shift
  case "$cmd" in
    clone) gtr::clone "$@"
    ;;
    cd) gtr::cd "$@"
    ;;
    list) gtr::list
    ;;
    *) echo "command not found: $cmd"
    ;;
  esac
}



