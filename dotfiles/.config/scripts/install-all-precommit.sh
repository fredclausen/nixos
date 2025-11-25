#!/usr/bin/env bash

# This script installs the pre-commit hook in all subdirectories of the current directory.

# get the working dir. if no argument is given use current dir, otherwise update from the given path

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

# install the pre-commit hook in all subdirectories of the given path
# look for .pre-commit-config.yaml files

DIRS_INSTALLED=()

for dir in $(find "$path" -name ".pre-commit-config.yaml" | cut -c 1- | rev | cut -c 24- | rev); do
    # if we are in a that is a child of a git repo, skip it

    # if we are in a that is a child of a git repo, skip it
    # loop through the parent dirs and check for a .git dir
    # this is probably a really stupid way of doing this.
    # we can probably just check for the existence of a .git *file* and just skip it if it exists
    # but I'm not sure if that breaks other crap. Basically, the logic here is that
    # if we are in a child directory that also includes a .git anything, bail out and don't update

    # split the path into an array
    IFS='/' read -r -a dirs <<< "$dir"
    # create the full path to the directory
    full_path=""
    skip=false
    found_top_level=false
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
            if [ "$found_top_level" == false ]; then
                found_top_level=true
                continue
            fi
        elif [ "$found_top_level" == true ]; then
            skip=true
        fi
    done


    if [ "$skip" == true ]; then
        continue
    fi

    # check if the pre-commit hook is already installed
    if [ -f "$dir/.git/hooks/pre-commit" ]; then
        continue
    fi
    # install the pre-commit hook
    echo -e "\nInstalling pre-commit hook in $dir"
    pushd "$dir" >/dev/null || exit
    pre-commit install
    DIRS_INSTALLED+=("$dir")
    popd >/dev/null || exit
done

if [ ${#DIRS_INSTALLED[@]} -eq 0 ]; then
    echo -e "\nNo pre-commit hooks installed"
else
    echo -e "\nPre-commit hooks installed in the following directories:"
    for dir in "${DIRS_INSTALLED[@]}"; do
        echo "$dir"
    done
fi
