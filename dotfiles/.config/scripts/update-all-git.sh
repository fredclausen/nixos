#!/usr/bin/env bash

# Update all git repositories in the current directory if no argument is given, otherwise update from the given path

if [ $# -eq 0 ]; then
  path=$(pwd)
else
  # if the path is relative, make it absolute
  if [[ $1 != /* ]]; then
    # follow the path to the directory
    pushd "$1" >/dev/null || exit
    # get the absolute path
    path=$(pwd)
    # return to the original directory
    popd >/dev/null || exit
  else
    path=$1
  fi
fi

UPDATED_DIRS=()
STASHED_DIRS=()
SKIPPED_DIRS=()

echo "Working....."

for dir in $(find "$path" -name ".git" | cut -c 1- | rev | cut -c 6- | rev); do
  # if we are in a that is a child of a git repo, skip it
  # loop through the parent dirs and check for a .git dir
  # this is probably a really stupid way of doing this.
  # we can probably just check for the existence of a .git *file* and just skip it if it exists
  # but I'm not sure if that breaks other crap. Basically, the logic here is that
  # if we are in a child directory that also includes a .git anything, bail out and don't update

  # split the path into an array
  IFS='/' read -r -a dirs <<<"$dir"
  # create the full path to the directory
  full_path=""
  skip=false
  skip_first_time=false
  # loop through the directories
  for d in "${dirs[@]}"; do
    # add the directory to the path
    if [ "$d" == "" ]; then
      continue
    else
      full_path="$full_path/$d"
    fi

    # if we are in a git repo, skip it
    if [ -d "$full_path/.git" ] || [ -f "$full_path/.git" ]; then
      if [ "$skip_first_time" == false ]; then
        skip_first_time=true
        continue
      fi
      skip=true
    fi
  done

  if [ "$skip" == true ]; then
    continue
  fi

  pushd "$dir" >/dev/null || exit
  # if the repo is dirty, skip
  if [ -n "$(git status --porcelain)" ]; then
    echo "Changes found in $dir, skipping"
    STASHED_DIRS+=("$dir")
    continue
  fi

  # if we are not in main or master branch, skip
  if [ "$(git rev-parse --abbrev-ref HEAD)" != "main" ] && [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ]; then
    echo "Not on main or master branch in $dir, skipping"
    SKIPPED_DIRS+=("$dir")
    continue
  fi

  # only output the result of the pull if there was changes
  if git pull | grep -vq 'Already up to'; then
    echo "Changes pulled in $dir"
    UPDATED_DIRS+=("$dir")
  fi
  popd >/dev/null || exit
done

if [ ${#UPDATED_DIRS[@]} -eq 0 ]; then
  echo -e "\nNo changes pulled"
else
  echo -e "\nChanges pulled in the following directories:"
  for dir in "${UPDATED_DIRS[@]}"; do
    echo "$dir"
  done
fi

if [ ${#STASHED_DIRS[@]} -eq 0 ]; then
  echo -e "\nNo changes stashed"
else
  echo -e "\nChanges in the following directories:"
  for dir in "${STASHED_DIRS[@]}"; do
    echo "$dir"
  done
fi

if [ ${#SKIPPED_DIRS[@]} -eq 0 ]; then
  echo -e "\nNo directories skipped"
else
  echo -e "\nThe following directories were skipped because not on main/master:"
  for dir in "${SKIPPED_DIRS[@]}"; do
    echo "$dir"
  done
fi
