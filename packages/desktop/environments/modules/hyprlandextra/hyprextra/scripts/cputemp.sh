#!/usr/bin/env bash

set -euo pipefail

temps=()

for hw in /sys/class/hwmon/hwmon*; do
    [[ -r "$hw/name" ]] || continue
    [[ $(cat "$hw/name") == "k10temp" ]] || continue

    for label in "$hw"/temp*_label; do
        [[ -r "$label" ]] || continue
        if [[ $(cat "$label") == Tccd* ]]; then
            input="${label/_label/_input}"
            temps+=("$(cat "$input")")
        fi
    done
done

if ((${#temps[@]} == 0)); then
    echo '{"text":" ?","class":"unknown"}'
    exit 0
fi

temp_millic=$(printf '%s\n' "${temps[@]}" | sort -nr | head -n1)
temp=$(awk "BEGIN { printf \"%.0f\", $temp_millic / 1000 }")

class="normal"
icon=""

if ((temp >= 85)); then
    class="critical"
    icon="❗"
elif ((temp >= 70)); then
    class="warning"
    icon="⚠️"
fi

jq -nc \
    --arg text "$icon ${temp}°C" \
    --arg class "$class" \
    '{text:$text, class:$class}'
