#!/usr/bin/env bash

alias cd="z"
# eval "$(pay-respects zsh --alias)"

command_not_found_handler() {
  # shellcheck disable=SC2145
  env _PR_LAST_COMMAND="$@" _PR_SHELL="zsh" _PR_MODE="cnf" _PR_ALIAS="$(alias)" pay-respects
}

alias f='eval $(_PR_LAST_COMMAND="$(fc -ln -1)" _PR_ALIAS="`alias`" _PR_SHELL="zsh" "pay-respects")'

bindkey '^[[F' end-of-line
bindkey '^[[H' beginning-of-line

function clear-screen-and-scrollback() {
    printf '\x1Bc'
    zle clear-screen
}

zle -N clear-screen-and-scrollback
bindkey '^L' clear-screen-and-scrollback

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

_widgets=$(zle -la)
if [[ -n "${_widgets[(r)down-line-or-beginning-search]}" ]]; then
  bindkey '^[[B' down-line-or-beginning-search
fi
if [[ -n "${_widgets[(r)up-line-or-beginning-search]}" ]]; then
  bindkey '^[[A' up-line-or-beginning-search
fi

alias uz="~/.config/scripts/update-zsh-stuff.sh"
alias ugh="~/.config/scripts/update-all-git.sh ~/GitHub"
alias ipc="~/.config/scripts/install-all-precommit.sh ~/GitHub"
alias scr="~/.config/scripts/sync-compose.sh"
alias ub="~/.config/scripts/update-brew.sh"
alias ls="lsd -la"
alias co="rustup update"
alias gc="gcverify"
alias gcn="gcnoverify"
alias gp="gpfred"
alias ng="nvim ~/GitHub"
alias ngs="nvim ~/Github/sdre-hub"
alias ngf="nvim ~/GitHub/freminal"
alias ngc="nvim_custom"
alias na="nvim ~/GitHub/docker-acarshub"
alias n="nvim"
alias rds="remove_dsstore"
alias cat="bat --color always"
alias c="code ."

alias updatedocker="updatedocker_ansible"
alias updatesystems="updatesystems_ansible"
alias rebootsystem="rebootsystem_ansible"

function updatedocker_ansible() {
  echo "Running Ansible playbook for Docker updates..."
  pushd ~/.ansible 1> /dev/null || return
  ansible-playbook -i inventory.yaml update_docker.yaml
  popd 1> /dev/null || return
}

function updatesystems_ansible() {
  echo "Running Ansible playbook for system updates..."
  pushd ~/.ansible 1> /dev/null || return
  ansible-playbook -i inventory.yaml update_servers.yaml --ask-become-pass
  popd 1> /dev/null || return
}

function rebootsystem_ansible() {
  # we need a system name passed in
  if [ -z "$1" ]; then
    echo "Please provide a system name to reboot"
    return
  fi

  echo "Running Ansible playbook for system reboot on $1..."
  pushd ~/.ansible 1> /dev/null || return
  ansible-playbook -i inventory.yaml -e "target_hosts=$1" reboot_systems.yaml --ask-become-pass
  popd 1> /dev/null || return
}

function nvim_custom () {
  if [ -z "$1" ]; then
    echo "Please provide a file to edit"
    return
  fi

  if [ -d /home/fred/ ]; then
    nvim ~/GitHub/"$1"
  elif [ -d /Users/fred ]; then
    nvim ~/GitHub/"$1"
  else
    echo "No user directory found"
  fi
}

function remove_dsstore() {
  if [ -d /home/fred/ ]; then
    pushd /home/fred/GitHub/"$1" 1> /dev/null || exit
  elif [ -d /Users/fred ]; then
    pushd /Users/fred/GitHub/"$1" 1> /dev/null || exit
  else
    echo "No user directory found"
    return
  fi

  # now find the script for removing .DS_Store files

  if [ -f ~/.config/scripts/remove_dsstore.sh ]; then
    ~/.config/scripts/remove_dsstore.sh
  elif [ -f ~/GitHub/fred/remove_dsstore.sh ]; then
    ~/GitHub/fred/fred-config/remove_dsstore.sh
  else
    echo "No script found"
  fi

  popd 1> /dev/null || exit
}

function gpfred() {
  sign
  if [ -d /home/fred/ ]; then
    pushd /home/fred/GitHub/"$1" 1> /dev/null || exit
  elif [ -d /Users/fred ]; then
    pushd /Users/fred/GitHub/"$1" 1> /dev/null || exit
  else
    echo "No user directory found"
    return
  fi

  git push
  popd 1> /dev/null || exit
}

function ua() {
  echo "Updating all"
  # if we're not on linux, we want to update oh-my-posh
  if [ -d /home/fred ]; then
      echo "Updating oh-my-posh...."
      curl -s https://ohmyposh.dev/install.sh | bash -s

      echo "Updating ZSH...."
      uz
  else
    echo "NixOS detected, skipping oh-my-posh update"
  fi

  # if .skipcargo exists, don't update cargo
  if [ -f ~/.skipcargo ]; then
    echo "Skipping cargo update"
  else
    echo "Updating cargo...."
    co
    cargo install-update -a
  fi
  echo "Updating Git...."
  ugh
  echo "Installing pre-commit hooks...."
  ipc
  echo "Updating brew...."
  ub
  # if bob command exists, AND ~/.local/share/bob exists, update bob
  if command -v bob &> /dev/null && [ -d ~/.local/share/bob ]; then
    echo "Updating bob...."
    bob update
  fi
}

function scar() {
  echo "Syncing all compose file (remote to local)...."
  scr remote all
}

function scal() {
  echo "Syncing all compose files (local to remote)...."
  scr local all
}

function sign() {
  mkdir -p ~/tmp/
  pushd ~/tmp/ 1> /dev/null || exit
  touch a.txt
  gpg --sign a.txt
  popd 1> /dev/null || exit
  rm -rf ~/tmp/
}

function gcverify() {
  # verify $1 and $2 exist
  if [ -z "$2" ]; then
    echo "Please provide a commit message"
    return
  fi

  sign
  if [ -d /home/fred/ ]; then
    pushd /home/fred/GitHub/"$1" 1> /dev/null || exit
  elif [ -d /Users/fred ]; then
    pushd /Users/fred/GitHub/"$1" 1> /dev/null || exit
  else
    echo "No user directory found"
    return
  fi
  git add .
  gcam "$2"
  popd 1> /dev/null || exit
}

function gcnoverify() {
  # verify $1 and $2 exist
  if [ -z "$2" ]; then
    echo "Please provide a commit message"
    return
  fi

  sign

  if [ -d /home/fred/ ]; then
    pushd /home/fred/GitHub/"$1" 1> /dev/null || exit
  elif [ -d /Users/fred ]; then
    pushd /Users/fred/GitHub/"$1" 1> /dev/null || exit
  else
    echo "No user directory found"
    return
  fi
  git add .
  git commit --all --no-verify -m "$2"
  popd 1> /dev/null || exit
}

fastfetch
