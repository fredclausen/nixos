#!/usr/bin/env zsh
# shellcheck shell=bash

garbagecollect() {
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
  updatenix
}

updatenix() {
  local nixos_dir="${GITHUB_DIR}/nixos"
  local macflake_dir="${GITHUB_DIR}/nixos/macflake"
  local target_dir pushed=false

  if [[ "$HOME" == /Users/* ]]; then
    target_dir="$macflake_dir"
    if [[ "$(pwd)" != "$target_dir" ]]; then
      pushd "$target_dir" >/dev/null || return
      pushed=true
    fi
    sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .
  else
    target_dir="$nixos_dir"
    if [[ "$(pwd)" != "$target_dir" ]]; then
      pushd "$target_dir" >/dev/null || return
      pushed=true
    fi
    sudo nixos-rebuild switch --flake .#"$(hostname)"
  fi

  [[ "$pushed" = true ]] && popd >/dev/null || return
}

updatedocker_ansible() {
  echo "Running Docker update playbook..."
  pushd "$ANSIBLE_DIR" >/dev/null || return
  ansible-playbook -i inventory.yaml update_docker.yaml
  popd >/dev/null || return
}

updatesystems_ansible() {
  echo "Running system update playbook..."
  pushd "$ANSIBLE_DIR" >/dev/null || return
  ansible-playbook -i inventory.yaml update_servers.yaml --ask-become-pass
  popd >/dev/null || return
}

rebootsystem_ansible() {
  [[ -z "$1" ]] && echo "Provide a system name" && return
  echo "Rebooting $1..."
  pushd "$ANSIBLE_DIR" >/dev/null || return
  ansible-playbook -i inventory.yaml -e "target_hosts=$1" reboot_systems.yaml --ask-become-pass
  popd >/dev/null || return
}


nvim_custom() {
  [[ -z "$1" ]] && echo "Provide a file to edit" && return
  nvim "${GITHUB_DIR}/$1"
}

remove_dsstore() {
  pushd "${GITHUB_DIR}/$1" >/dev/null || { echo "Repo not found"; return; }

  if [[ -f "${HOME}/.config/scripts/remove_dsstore.sh" ]]; then
    "${HOME}/.config/scripts/remove_dsstore.sh"
  elif [[ -f "${GITHUB_DIR}/remove_dsstore.sh" ]]; then
    "${GITHUB_DIR}/remove_dsstore.sh"
  else
    echo "No remove_dsstore script found"
  fi

  popd >/dev/null || return
}

gppush() {
  sign
  pushd "${GITHUB_DIR}/$1" >/dev/null || { echo "Repo not found"; return; }
  git push
  popd >/dev/null || return
}

scar() {
  echo "Sync compose (remote→local)…"
  scr remote all
}

scal() {
  echo "Sync compose (local→remote)…"
  scr local all
}

sign() {
  mkdir -p "${HOME}/tmp"
  pushd "${HOME}/tmp" >/dev/null || return
  touch a.txt
  gpg --sign a.txt
  popd >/dev/null || return
  rm -rf "${HOME}/tmp"
}

gcverify() {
  [[ -z "$2" ]] && echo "Provide commit message" && return
  sign
  pushd "${GITHUB_DIR}/$1" >/dev/null || return
  git add .
  gcam "$2"
  popd >/dev/null || return
}

gcnoverify() {
  [[ -z "$2" ]] && echo "Provide commit message" && return
  sign
  pushd "${GITHUB_DIR}/$1" >/dev/null || return
  git add .
  git commit --all --no-verify -m "$2"
  popd >/dev/null || return
}
