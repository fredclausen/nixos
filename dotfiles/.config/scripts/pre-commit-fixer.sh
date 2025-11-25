#!/usr/bin/env bash

# get the dir to loop through from args passed

# if the dir is not passed, then exit
if [ -z "$1" ]; then
  echo "No directory provided. Exiting."
  exit 1
fi

# if the dir does not exist, then exit

if [ ! -d "$1" ]; then
  echo "Directory does not exist. Exiting."
  exit 1
fi

python="\/etc\/profiles\/per-user\/$USER\/bin\/python3"
python_grep="/etc/profiles/per-user/$USER/bin/python3"
pre_commit="\/etc\/profiles\/per-user\/$USER\/bin\/pre-commit"
pre_commit_grep="/etc/profiles/per-user/$USER/bin/pre-commit"

# loop through the files in the directory
# if there is a .git file in the directory, then check the .git/hooks/pre-commit file exists

for file in "$1"/*; do
  if [ -d "$file" ]; then
    if [ -f "$file/.git/hooks/pre-commit" ]; then
      # if the line container INSTALL_PYTHON does not equal `INSTALL_PYTHON=$(which python3)`
      # then replace the line with `INSTALL_PYTHON=$(which python3)`

        if [ "$(grep -c "INSTALL_PYTHON=$python_grep" "$file/.git/hooks/pre-commit")" -eq 0 ]; then
            # replace the line with `INSTALL_PYTHON=$(which python3)`
            sed -i "s/INSTALL_PYTHON=.*/INSTALL_PYTHON=$python/" "$file/.git/hooks/pre-commit"
            echo "pre-commit file python updated in $file"
        else
            echo "pre-commit file python already updated in $file"
        fi

        if [ "$(grep -c "exec $pre_commit_grep" "$file/.git/hooks/pre-commit")" -eq 0 ]; then
            # replace the text with `exec $(which pre-commit)`
            sed -i "s|^exec .*|exec $pre_commit \"\$\{ARGS\[\@\]\}\"|" "$file/.git/hooks/pre-commit"
            echo "pre-commit file exec updated in $file"
        else
            echo "pre-commit file exec already updated in $file"
        fi
    fi
  fi
done
