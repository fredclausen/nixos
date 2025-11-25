#!/usr/bin/env bash

# if brew is present, run brew update

if command -v brew &>/dev/null; then
  echo "Brew is installed. Updating brew..."
  brew upgrade
  brew upgrade --cask
else
  echo "Brew is not installed. Skipping brew upgrade."
fi
