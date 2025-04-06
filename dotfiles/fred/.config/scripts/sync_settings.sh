#!/usr/bin/env bash

# check all root level folders in ~/.config. If they are not a symlink, then list them

IGNORE_LIST=(
"Code"
"Brave Browser"
"1Password"
"balena-etcher"
"BraveSoftware"
"chromium"
"dconf"
"discord"
"EOS-greeter.conf"
"eos-update-notifier.first_init"
"GitHub Desktop"
"gnome-session"
"google-chrome"
"google-chrome-beta"
"google-chrome-unstable"
"gtk-3.0"
"gtk-4.0"
"ibus"
"Ledger Live"
"microsoft-edge-dev"
"mimeapps.list"
"nautilus"
"pulse"
"systemd"
"TradingView"
"@trezor"
"user-dirs.dirs"
"user-dirs.locale"
"vivaldi"
"vivaldi-snapshot"
"yay"
)

NOT_IN_IGNORE_LIST=()

if [ -d ~/.config ]; then
    for file in ~/.config/*; do
        if [ -L "$file" ]; then
            echo "$file is a symlink. Skipping..."
        else
            # get the basename of the file
            base=$(basename "$file")
            # see if the file is in the ignore list
            if [[ ! " ${IGNORE_LIST[*]} " =~ ${base} ]]; then
                NOT_IN_IGNORE_LIST+=("${base}")
            fi
        fi
    done
fi

for i in "${NOT_IN_IGNORE_LIST[@]}"; do
    echo "$i"
done

# Creating list of installed packages

pacman -Qqn > /home/fred/GitHub/fred/fred-config/pkglist-native.txt
pacman -Qqm > /home/fred/GitHub/fred/fred-config/pkglist-aur.txt
