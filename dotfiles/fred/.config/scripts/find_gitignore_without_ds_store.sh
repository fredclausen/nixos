#!/usr/bin/env bash

# Find all .gitignore files that do not contain .DS_Store
# Start with the current directory, check all children directories
# and print the path of the .gitignore files that do not contain .DS_Store
# if there is no .gitignore file in a directory, print the path of the directory

# step one, find all directories with .git directories in them

# find all .git directories
git_dirs=$(find . -type d -name .git)

# loop through all of the .git directories

for git_dir in $git_dirs; do
  # get the parent directory of the .git directory
  parent_dir=$(dirname "$git_dir")
  # check if there is a .gitignore file in the parent directory
  if [ -f "$parent_dir"/.gitignore ]; then
    # check if the .gitignore file contains .DS_Store
    if ! grep -q .DS_Store "$parent_dir"/.gitignore; then
      # append .DS_Store to the .gitignore file
      echo ".DS_Store" >>"$parent_dir"/.gitignore
      echo "$parent_dir"
    fi
  else
    # print the path of the directory
    echo "$parent_dir"
    # create the .gitignore file
    touch "$parent_dir"/.gitignore
    echo ".DS_Store" >>"$parent_dir"/.gitignore
  fi
done
