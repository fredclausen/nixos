#!/usr/bin/env bash
set -euo pipefail

# Collect blocking inhibitors (idle/sleep, MODE=block)
mapfile -t items < <(
    systemd-inhibit --list | awk '
    NR>1 && $NF=="block" && $6 ~ /(idle|sleep)/ {
      who=$1
      if (who == "sway-audio-idle-inhibit") {
        print "Audio"
      } else if (who == "caffeine") {
        print "Caffeine"
      } else {
        print who
      }
    }
  '
)

count=${#items[@]}

if ((count == 0)); then
    sentence="No idle inhibitors active"
elif ((count == 1)); then
    sentence="${items[0]} is prohibiting sleep"
elif ((count == 2)); then
    sentence="${items[0]} and ${items[1]} are prohibiting sleep"
else
    sentence="${items[0]}"
    for ((i = 1; i < count - 1; i++)); do
        sentence+=", ${items[i]}"
    done
    sentence+=", and ${items[count - 1]} are prohibiting sleep"
fi

# Decide visual state
if systemctl --user --quiet is-active caffeine-inhibit.service; then
    text="  Awake"
    class="caffeine"
elif ((count > 0)); then
    text="  Busy"
    class="external"
else
    text="  Idle"
    class="inactive"
fi

# Emit ONE clean JSON object
printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' \
    "$text" "$class" "$sentence"
