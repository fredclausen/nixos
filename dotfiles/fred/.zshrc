#!/usr/bin/env bash

export ZSH="$HOME/.oh-my-zsh"

# if we're on mac and homebrew is installed, add it to the path
if [ -d "/opt/homebrew" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
fi

# if ~/.local/bin exists, add it to the PATH
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# /home/fred/.local/share/bob exists, add it to the PATH
if [ -d "$HOME/.local/share/bob" ]; then
  export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
fi

# if /home/fred/.fzf/bin exists, add it to the PATH
if [ -d "$HOME/.fzf/bin" ]; then
  export PATH="$HOME/.fzf/bin:$PATH"
fi

# if /usr/bin/keychain exists, run eval $(keychain --eval --quiet)
if [ -f "/usr/bin/keychain" ]; then
  eval "$(keychain --eval --quiet)"
fi

export ENABLE_CORRECTION="true"
export COMPLETION_WAITING_DOTS="true"
export HIST_STAMPS="mm/dd/yyyy"

#source "$ZSH/oh-my-zsh.sh"
autoload -Uz compinit
compinit
fastfetch -c paleofetch.jsonc

export plugins=(
  git
  history-substring-search
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
  sudo
  copyfile
  copybuffer
  history
  zoxide
)

eval "$(fzf --zsh)"

# shellcheck source=/dev/null
#source "$ZSH/oh-my-zsh.sh"

# perform cleanup so a new initialization in current session works
# commented out because this bit is actually run in the OMP init script.
# for some reason what we're doing above fucks with the OMP init.
# moving OMP init to the end of this (or running this logic) fixes it
# if [[ "$(zle -lL self-insert)" = *"_posh-tooltip"* ]]; then
#   zle -N self-insert
# fi
# if [[ "$(zle -lL zle-line-init)" = *"_posh-zle-line-init"* ]]; then
#   zle -N zle-line-init
# fi

# restore broken key bindings
# https://github.com/JanDeDobbeleer/oh-my-posh/discussions/2617#discussioncomment-3911044

source "$ZSH/oh-my-zsh.sh"

# if .cargo is present, add it
if [ -f "$HOME/.cargo/env" ]; then
   # shellcheck disable=SC1091
   source "$HOME"/.cargo/env
fi

eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.toml)"
