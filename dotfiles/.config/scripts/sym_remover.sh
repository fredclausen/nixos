#!/usr/bin/env bash

# run find, grep, remove all consecutive spaces
mapfile -t all < <(find . -type l -ls | grep -Eo '\S+' | grep 'stow' | grep '\.config')

count=0

for item in "${all[@]}"; do
  echo "$count Removing $item"
  rm -rf "$item"
  count=$((count + 1))
done
