#!/usr/bin/env bash
set -euo pipefail

if nixos-needsreboot --dry-run >/dev/null 2>&1; then
    echo '{"text":"󰜉","class":"reboot","tooltip":"Reboot required"}'
    exit 0
fi

updates=$(nix-channel --list 2>/dev/null | wc -l || true)

if ((updates > 0)); then
    echo "{\"text\":\"󰏗\",\"class\":\"updates\",\"tooltip\":\"System updates available\"}"
    exit 0
fi

echo '{"text":"󰏗","class":"clean","tooltip":"System up to date"}'
