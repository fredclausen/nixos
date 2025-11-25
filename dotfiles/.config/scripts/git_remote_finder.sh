#!/usr/bin/env bash

# Loop through ~/GitHub directory. For each top level dir run git remote -v and cut the output to get the remote URL.

repos=()

for dir in ~/GitHub/*; do
  if [ -d "$dir" ]; then
    cd "$dir" || exit 1
    repos+=("$(git remote -v | cut -f2 | cut -d' ' -f1 | head -n 1)")
  fi
done

# sort and remove duplicates

# don't show the output
echo "${repos[@]}" | tr ' ' '\n' | sort | uniq

# show the number of repos
echo "Number of repos: ${#repos[@]}"
