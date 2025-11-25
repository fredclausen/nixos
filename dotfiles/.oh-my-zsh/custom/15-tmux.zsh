#!/usr/bin/env zsh
# shellcheck shell=bash

# --- Auto-start tmux if interactive and no tmux session ---
if [[ -z "$TMUX" && -n "$PS1" ]]; then
  exec tmux new-session -A -s main
fi
