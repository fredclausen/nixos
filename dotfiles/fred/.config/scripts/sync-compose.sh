#!/usr/bin/env bash

# create a backup of the adsb-compose/docker-compose.yml file
# and then copy the new docker-compose.yml file to the adsb-compose directory

# backup the current docker-compose.yml file

# check to see if /home/fred/ exits. If so, set $HOME_DIR to /home/fred
# otherwise set $HOME_DIR to /Users/fred

if [[ -d /home/fred ]]; then
  HOME_DIR=/home/fred
else
  HOME_DIR=/Users/fred
fi

function sync_compose_remote_to_local() {
  ip=$1
  remote_path_compose=$2
  remote_path_env=$3
  local_path_compose=$4
  local_path_env=$5
  port=$6
  user=$7

  scp_cmd=(scp -P "$port")

  # if the 8th parameter is set to true, then use the legacy scp command
  if [[ $8 == true ]]; then
    scp_cmd+=("-O")
  fi

  # verify all the parameters are set

  if [[ -z $ip ]]; then
    echo "IP address not set"
    exit 1
  fi

  if [[ -z $remote_path_compose ]]; then
    echo "Remote path to docker-compose.yml file not set"
    exit 1
  fi

  if [[ -z $remote_path_env ]]; then
    echo "Remote path to .env file not set"
    exit 1
  fi

  if [[ -z $port ]]; then
    echo "Port not set"
    exit 1
  fi

  if [[ -z $user ]]; then
    echo "User not set"
    exit 1
  fi

  if [[ -z $local_path_compose ]]; then
    echo "Local path to docker-compose.yml file not set"
    exit 1
  else
    # get the full path to the docker-compose.yaml file
    local_path=$(realpath "$local_path_compose")
    compose_file_name=$(basename "$local_path")
    local_path=$(dirname "$local_path")
  fi

  if [[ ! -f $local_path_compose ]]; then
    echo "Local path to docker-compose.yml file does not exist"
    exit 1
  fi

  if [[ -z $local_path_env ]]; then
    echo "Local path to .env file not set"
    exit 1
  else
    # get the full path to the .env file
    env_file_name=$(basename "$local_path_env")
  fi

  if [[ ! -f $local_path_env ]]; then
    echo "Local path to .env file does not exist"
    exit 1
  fi

  # backup the current docker-compose.yml file
  if mv "$local_path_compose" "$local_path/$compose_file_name".bak; then
    echo "docker-compose.yml file backed up successfully"
  else
    echo "docker-compose.yml file failed to backup"
    exit 1
  fi

  # back up the current .env file

  if mv "$local_path_env" "$local_path/$env_file_name".bak; then
    echo ".env file backed up successfully"
  else
    echo ".env file failed to backup"
    exit 1
  fi

  # copy the new docker-compose.yml file to the adsb-compose directory
  # from the ADSB Hub @ $ip:$remote_path_compose

  if "${scp_cmd[@]}" "$user@$ip:$remote_path_compose" "$local_path_compose"; then
    echo "New docker-compose.yml file copied successfully"
  else
    echo "New docker-compose.yml file failed to copy"
    exit 1
  fi

  # copy the new .env file to the adsb-compose directory
  # from the ADSB Hub @ $ip:$remote_path_env

  if "${scp_cmd[@]}" "$user@$ip:$remote_path_env" "$local_path_env"; then
    echo "New .env file copied successfully"
  else
    echo "New .env file failed to copy"
    exit 1
  fi

  # verify the new docker-compose.yml file looks good

  if docker compose -f "$local_path_compose" config --quiet; then
    echo "New docker-compose.yml file looks good"
  else
    echo "New docker-compose.yml file has errors"
    exit 1
  fi

  # Delete the backup file
  rm "$local_path_compose".bak
  rm "$local_path_env".bak
}

function sync_compose_local_to_remote() {
  ip=$1
  remote_path_compose=$2
  remote_path_env=$3
  local_path_compose=$4
  local_path_env=$5
  port=$6
  user=$7

  scp_cmd=(scp -P "$port")

  # if the 8th parameter is set to true, then use the legacy scp command
  if [[ $8 == true ]]; then
    scp_cmd+=("-O")
  fi

  # verify all the parameters are set

  if [[ -z $ip ]]; then
    echo "IP address not set"
    exit 1
  fi

  if [[ -z $remote_path_compose ]]; then
    echo "Remote path to docker-compose.yml file not set"
    exit 1
  fi

  if [[ -z $remote_path_env ]]; then
    echo "Remote path to .env file not set"
    exit 1
  fi

  if [[ -z $port ]]; then
    echo "Port not set"
    exit 1
  fi

  if [[ -z $user ]]; then
    echo "User not set"
    exit 1
  fi

  if [[ -z $local_path_compose ]]; then
    echo "Local path to docker-compose.yml file not set"
    exit 1
  else
    # get the full path to the docker-compose.yaml file
    local_path=$(realpath "$local_path_compose")
    compose_file_name=$(basename "$local_path")
    local_path=$(dirname "$local_path")
  fi

  if [[ ! -f $local_path_compose ]]; then
    echo "Local path to docker-compose.yml file does not exist"
    exit 1
  fi

  if [[ -z $local_path_env ]]; then
    echo "Local path to .env file not set"
    exit 1
  else
    # get the full path to the .env file
    env_file_name=$(basename "$local_path_env")
  fi

  if [[ ! -f $local_path_env ]]; then
    echo "Local path to .env file does not exist"
    exit 1
  fi

  # verify the new docker-compose.yml file looks good

  if docker compose -f "$local_path_compose" config --quiet; then
    echo "New docker-compose.yml file looks good"
  else
    echo "New docker-compose.yml file has errors"
    exit 1
  fi

  # copy the new docker-compose.yml file to the adsb-compose directory

  if "${scp_cmd[@]}" "$local_path_compose" "$user@$ip:$remote_path_compose"; then
    echo "New docker-compose.yml file copied successfully"
  else
    echo "New docker-compose.yml file failed to copy"
    exit 1
  fi

  # copy the new .env file to the adsb-compose directory

  if "${scp_cmd[@]}" "$local_path_env" "$user@$ip:$remote_path_env"; then
    echo "New .env file copied successfully"
  else
    echo "New .env file failed to copy"
    exit 1
  fi
}

# check input parameters

# two input parameters are required
# first is going to be either local or remote
# the second is going to be all, adsbhub, brandon or vps
# any other values are invalid

if [[ -z $1 ]]; then
  echo "First parameter sync direction not set"
  echo "Should be either local or remote"
  echo "local = copy from local to remote"
  echo "remote = copy from remote to local"
  exit 1
else
  if [[ $1 != "local" && $1 != "remote" ]]; then
    echo "First parameter is invalid"
    echo "Should be either local or remote"
    exit 1
  fi

  sync_direction=$1
fi

if [[ -z $2 ]]; then
  echo "Second parameter not set"
  echo "Should be either all, adsbhub, brandon or vps"
  exit 1
else
  if [[ $2 != "all" && $2 != "sdrhub" && $2 != "brandon" && $2 != "vps" && $2 != "hfdlhub-1" && $2 != "hfdlhub-2" && $2 != "acarshub" && $2 != "vdlmhub" ]]; then
    echo "Second parameter sync target is invalid"
    echo "Should be either all, sdrhub, acarshub, brandon, vdlmhub, or vps"
    exit 1
  fi

  sync_target=$2
fi

if [[ $sync_direction == "remote" ]]; then
  if [[ $sync_target == "all" || $sync_target == "sdrhub" ]]; then
    echo "Backing up SDR Hub"
    sync_compose_remote_to_local "192.168.31.20" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/sdrhub/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/sdrhub/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "hfdlhub-1" ]]; then
    echo "Backing up HFDL Hub 1"
    sync_compose_remote_to_local "192.168.31.19" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/hfdlhub-1/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/hfdlhub-1/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "hfdlhub-2" ]]; then
    echo "Backing up HFDL Hub 2"
    sync_compose_remote_to_local "192.168.31.17" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/hfdlhub-2/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/hfdlhub-2/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "acarshub" ]]; then
    echo "Backing up ACARS Hub"
    sync_compose_remote_to_local "192.168.31.24" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/acarshub/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/acarshub/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "vdlmhub" ]]; then
    echo "Backing up VDL Hub"
    sync_compose_remote_to_local "192.168.31.23" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/vdlmhub/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/vdlmhub/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "vps" ]]; then
    echo "Backing up fredclausen.com"
    sync_compose_remote_to_local "fredclausen.com" /home/fred/docker-compose.yaml /home/fred/.env $HOME_DIR/GitHub/adsb-compose/vps/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/vps/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "brandon" ]]; then
    echo "Backing up Brandon"
    sync_compose_remote_to_local "73.242.200.187" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/brandon/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/brandon/.env "3222" fred true
  fi
elif [[ $sync_direction == "local" ]]; then
  if [[ $sync_target == "all" || $sync_target == "sdrhub" ]]; then
    echo "Pushing sdr Hub"
    sync_compose_local_to_remote "192.168.31.20" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/sdrhub/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/sdrhub/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "hfdlhub-1" ]]; then
    echo "Pushing HFDL Hub 1"
    sync_compose_local_to_remote "192.168.31.19" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/hfdlhub-1/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/hfdlhub-1/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "hfdlhub-2" ]]; then
    echo "Pushing HFDL Hub 2"
    sync_compose_local_to_remote "192.168.31.17" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/hfdlhub-2/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/hfdlhub-2/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "acarshub" ]]; then
    echo "Pushing ACARS Hub"
    sync_compose_local_to_remote "192.168.31.24" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/acarshub/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/acarshub/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "vdlmhub" ]]; then
    echo "Pushing VDL Hub"
    sync_compose_local_to_remote "192.168.31.23" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/vdlmhub/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/vdlmhub/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "vps" ]]; then
    echo "Pushing fredclausen.com"
    sync_compose_local_to_remote "fredclausen.com" /home/fred/docker-compose.yaml /home/fred/.env $HOME_DIR/GitHub/adsb-compose/vps/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/vps/.env 22 fred
  fi

  if [[ $sync_target == "all" || $sync_target == "brandon" ]]; then
    echo "Pushing Brandon"
    sync_compose_local_to_remote "73.242.200.187" /opt/adsb/docker-compose.yaml /opt/adsb/.env $HOME_DIR/GitHub/adsb-compose/brandon/docker-compose.yaml $HOME_DIR/GitHub/adsb-compose/brandon/.env "3222" fred true
  fi
fi
