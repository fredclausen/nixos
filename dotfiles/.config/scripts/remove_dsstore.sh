#!/usr/bin/env bash

# check and see if a dir was passed it. If so, use that as the base dir
# otherwise, use the current dir
#
if [ -d "$1" ]; then
  BASE_DIR=$1
else
  BASE_DIR=$(pwd)
fi

# convert the base dir to an absolute path

BASE_DIR=$(
  cd "$BASE_DIR" || exit 1
  pwd
)

# find all .DS_Store files in the base dir and remove them

find "$BASE_DIR" -name .DS_Store -exec rm {} \;
