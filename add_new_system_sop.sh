#!/usr/bin/env bash

echo "Generate new age keys for sops"
mkdir -p ~/.config/sops/age
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt

echo "Remove old SSH keys"
ssh-add -D
rm -rf ~/.ssh/id_rsa ~/.ssh/id_rsa.pub ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub ~/.ssh/authorized_keys
