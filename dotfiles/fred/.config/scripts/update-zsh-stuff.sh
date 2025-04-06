#!/usr/bin/env bash

pushd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || exit
git pull
popd || exit

pushd  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions || exit
git pull
popd || exit

# if ~.fzf exists, update it
if [ -d ~/.fzf ]; then
  pushd ~/.fzf || exit
  git pull
  ~/.fzf/install
  popd || exit
fi
