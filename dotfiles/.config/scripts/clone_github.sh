#!/usr/bin/env bash

# grab the path we're going to clone. It will be the first parameter

path=$1

# verify that the path is not empty

if [ -z "$path" ]; then
  echo "You must provide a path to clone"
  exit 1
fi

# see if the path is a full system path. If it is, run mkdir -p on the path
# if it is not, we'll assume the path is relative to the current directory

if [[ $path == /* ]] || [[ $path == ~/* ]]; then
  mkdir -p "$path" || exit 1
else
  mkdir -p "./$path" || exit 1
fi

# read in the repos to clone from repos.txt

repos=()
while read -r line; do
  repos+=("$line")
done <repos.txt

pushd "$path" || exit 1

cloned=()
skipped=()

# clone the repos

for repo in "${repos[@]}"; do
  # we need to split the url by / and get the last element to use as the directory name
  # then remove .git from the end of the string
  repo_name=$(echo "$repo" | rev | cut -d'/' -f1 | rev | sed 's/\.git$//')

  if [ -d "$repo_name" ]; then
    echo "Repo $repo already exists. Skipping"
    skipped+=("$repo_name")
    continue
  fi

  echo "Cloning $repo into $path"
  git clone "$repo"
  cloned+=("$repo_name")
done

for repo in "${cloned[@]}"; do
  echo "Cloned $repo"
done

for repo in "${skipped[@]}"; do
  echo "Skipped $repo"
done
