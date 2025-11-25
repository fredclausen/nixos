#!/usr/bin/env bash
# Sync Docker Compose files between local and remote hosts

set -euo pipefail

########################################
#  Helpers
########################################

die() { echo "ERROR: $*" >&2; exit 1; }

require_file() { [[ -f "$1" ]] || die "File not found: $1"; }
require_nonempty() { [[ -n "$1" ]] || die "$2 not set"; }

########################################
#  Copy Remote → Local
########################################

sync_compose_remote_to_local() {
  local ip=$1 remote_compose=$2 remote_env=$3 local_compose=$4 local_env=$5 port=$6 user=$7 use_legacy=${8:-false}

  require_nonempty "$ip" "IP"
  require_nonempty "$remote_compose" "Remote compose"
  require_nonempty "$remote_env" "Remote env"
  require_nonempty "$local_compose" "Local compose"
  require_nonempty "$local_env" "Local env"
  require_nonempty "$port" "Port"
  require_nonempty "$user" "User"

  require_file "$local_compose"
  require_file "$local_env"

  local local_dir
  local_dir=$(dirname "$(realpath "$local_compose")")
  local compose_name env_name

  compose_name=$(basename "$local_compose")
  env_name=$(basename "$local_env")

  # Build SCP command
  local scp_cmd=(scp -P "$port")
  [[ "$use_legacy" == true ]] && scp_cmd+=("-O")

  mv "$local_compose" "$local_dir/${compose_name}.bak"
  mv "$local_env" "$local_dir/${env_name}.bak"

  "${scp_cmd[@]}" "$user@$ip:$remote_compose" "$local_compose"
  "${scp_cmd[@]}" "$user@$ip:$remote_env" "$local_env"

  docker compose -f "$local_compose" config --quiet || die "Compose validation failed"

  rm "$local_dir/${compose_name}.bak" "$local_dir/${env_name}.bak"
}

########################################
#  Copy Local → Remote
########################################

sync_compose_local_to_remote() {
  local ip=$1 remote_compose=$2 remote_env=$3 local_compose=$4 local_env=$5 port=$6 user=$7 use_legacy=${8:-false}

  require_nonempty "$ip" "IP"
  require_nonempty "$remote_compose" "Remote compose"
  require_nonempty "$remote_env" "Remote env"
  require_nonempty "$local_compose" "Local compose"
  require_nonempty "$local_env" "Local env"
  require_nonempty "$port" "Port"
  require_nonempty "$user" "User"

  require_file "$local_compose"
  require_file "$local_env"

  docker compose -f "$local_compose" config --quiet || die "Compose validation failed"

  # Build SCP command
  local scp_cmd=(scp -P "$port")
  [[ "$use_legacy" == true ]] && scp_cmd+=("-O")

  "${scp_cmd[@]}" "$local_compose" "$user@$ip:$remote_compose"
  "${scp_cmd[@]}" "$local_env" "$user@$ip:$remote_env"
}

########################################
#  Input Parsing
########################################

[[ $# -lt 2 ]] && die "Usage: $0 <local|remote> <target>"

sync_direction=$1
sync_target=$2

case "$sync_direction" in
  local|remote) ;;
  *) die "First parameter must be local|remote" ;;
esac

case "$sync_target" in
  all|sdrhub|acarshub|brandon|vdlmhub|vps|hfdlhub-1|hfdlhub-2) ;;
  *) die "Invalid target" ;;
esac

########################################
#  Paths
########################################

LOCAL_BASE="$HOME/GitHub/adsb-compose"

########################################
#  Target Table
########################################

sync_host() {
  local dir="$1" ip="$2" remote_comp="$3" remote_env="$4" port="$5" legacy="$6"

  local lc="$LOCAL_BASE/$dir/docker-compose.yaml"
  local le="$LOCAL_BASE/$dir/.env"

  if [[ $sync_direction == "remote" ]]; then
    echo "Backing up $dir"
    sync_compose_remote_to_local "$ip" "$remote_comp" "$remote_env" "$lc" "$le" "$port" "fred" "$legacy"
  else
    echo "Pushing $dir"
    sync_compose_local_to_remote "$ip" "$remote_comp" "$remote_env" "$lc" "$le" "$port" "fred" "$legacy"
  fi
}

########################################
#  Dispatch Table
########################################

[[ $sync_target == "all" || $sync_target == "sdrhub" ]]     && sync_host "sdrhub"     "192.168.31.20" "/opt/adsb/docker-compose.yaml" "/opt/adsb/.env" 22 false
[[ $sync_target == "all" || $sync_target == "hfdlhub-1" ]]  && sync_host "hfdlhub-1"  "192.168.31.19" "/opt/adsb/docker-compose.yaml" "/opt/adsb/.env" 22 false
[[ $sync_target == "all" || $sync_target == "hfdlhub-2" ]]  && sync_host "hfdlhub-2"  "192.168.31.17" "/opt/adsb/docker-compose.yaml" "/opt/adsb/.env" 22 false
[[ $sync_target == "all" || $sync_target == "acarshub" ]]   && sync_host "acarshub"   "192.168.31.24" "/opt/adsb/docker-compose.yaml" "/opt/adsb/.env" 22 false
[[ $sync_target == "all" || $sync_target == "vdlmhub" ]]    && sync_host "vdlmhub"    "192.168.31.23" "/opt/adsb/docker-compose.yaml" "/opt/adsb/.env" 22 false
[[ $sync_target == "all" || $sync_target == "vps" ]]        && sync_host "vps"        "fredclausen.com" "/home/fred/docker-compose.yaml" "/home/fred/.env" 22 false
[[ $sync_target == "all" || $sync_target == "brandon" ]]    && sync_host "brandon"    "73.242.200.187" "/opt/adsb/docker-compose.yaml" "/opt/adsb/.env" 3222 true
