#!/bin/zsh

alias cd="z"
# eval "$(pay-respects zsh --alias)"

bindkey '^[[F' end-of-line
bindkey '^[[H' beginning-of-line

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

if [ -d /home/fred/ ]; then
  alias uz="~/GitHub/fred-config/update-zsh-stuff.sh"
  alias ugh="~/GitHub/fred-config/update-all-git.sh ~/GitHub"
  alias ipc="~/GitHub/fred-config/install-all-precommit.sh ~/GitHub"
  alias scr="~/GitHub/fred-config/sync-compose.sh"
  alias ub="~/GitHub/fred-config/update-brew.sh"
elif [ -d /Users/fred ]; then
  alias uz="~/GitHub/fred-config/update-zsh-stuff.sh"
  alias ugh="~/GitHub/fred-config/update-all-git.sh ~/GitHub"
  alias ipc="~/GitHub/fred-config/install-all-precommit.sh ~/GitHub"
  alias scr="~/GitHub/fred-config/sync-compose.sh"
  alias ub="~/GitHub/fred-config/update-brew.sh"
fi

alias ls="lsd -l"
alias lsa="lsd -la"
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

function nvim_custom () {
  if [ -z "$1" ]; then
    echo "Please provide a file to edit"
    return
  fi

  if [ -d /home/fred/ ]; then
    nvim ~/GitHub/$1
  elif [ -d /Users/fred ]; then
    nvim ~/GitHub/$1
  else
    echo "No user directory found"
  fi
}

function remove_dsstore() {
  if [ -d /home/fred/ ]; then
    pushd /home/fred/GitHub/$1 1> /dev/null
  elif [ -d /Users/fred ]; then
    pushd /Users/fred/GitHub/$1 1> /dev/null
  else
    echo "No user directory found"
    return
  fi

  # now find the script for removing .DS_Store files

  if [ -f ~/GitHub/fred-config/remove_dsstore.sh ]; then
    ~/GitHub/fred-config/remove_dsstore.sh
  elif [ -f ~/GitHub/fred/remove_dsstore.sh ]; then
    ~/GitHub/fred/fred-config/remove_dsstore.sh
  else
    echo "No script found"
  fi

  popd 1> /dev/null
}

function gpfred() {
  sign
  if [ -d /home/fred/ ]; then
    pushd /home/fred/GitHub/$1 1> /dev/null
  elif [ -d /Users/fred ]; then
    pushd /Users/fred/GitHub/$1 1> /dev/null
  else
    echo "No user directory found"
    return
  fi

  git push
  popd 1> /dev/null
}

function ua() {
  echo "Updating all"
  # if we're on linux, we want to update oh-my-posh
  if !command -v nixos-rebuild &> /dev/null; then
    if [ -d /home/fred/ ]; then
      echo "Updating oh-my-posh...."
      curl -s https://ohmyposh.dev/install.sh | bash -s

      echo "Updating ZSH...."
      uz
    fi
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
  pushd ~/tmp/ 1> /dev/null
  touch a.txt
  gpg --sign a.txt
  popd 1> /dev/null
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
    pushd /home/fred/GitHub/$1 1> /dev/null
  elif [ -d /Users/fred ]; then
    pushd /Users/fred/GitHub/$1 1> /dev/null
  else
    echo "No user directory found"
    return
  fi
  git add .
  gcam $2
  popd 1> /dev/null
}

function gcnoverify() {
  # verify $1 and $2 exist
  if [ -z "$2" ]; then
    echo "Please provide a commit message"
    return
  fi

  sign

  if [ -d /home/fred/ ]; then
    pushd /home/fred/GitHub/$1 1> /dev/null
  elif [ -d /Users/fred ]; then
    pushd /Users/fred/GitHub/$1 1> /dev/null
  else
    echo "No user directory found"
    return
  fi
  git add .
  git commit --all --no-verify -m $2
  popd 1> /dev/null
}

fastfetch
