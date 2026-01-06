{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.ci.githubRunners;
  hostname = config.networking.hostName;

  ############################################################
  # Cleanup helper (same semantics as Linux ExecStartPre)
  ############################################################
  cleanupRunner = pkgs.writeShellScript "github-runner-cleanup" ''
    set -euo pipefail

    RUNNER_NAME="$1"
    TOKEN_FILE="$2"
    REPO="$3"

    TOKEN="$(cat "$TOKEN_FILE")"

    RUNNER_ID="$(
      ${pkgs.curl}/bin/curl -sf \
        -H "Authorization: token $TOKEN" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/$REPO/actions/runners" \
      | ${pkgs.jq}/bin/jq -r --arg NAME "$RUNNER_NAME" \
          '.runners[] | select(.name == $NAME) | .id'
    )"

    if [ -n "$RUNNER_ID" ]; then
      echo "Deleting stale GitHub runner: $RUNNER_NAME (id=$RUNNER_ID)"
      ${pkgs.curl}/bin/curl -sf -X DELETE \
        -H "Authorization: token $TOKEN" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/$REPO/actions/runners/$RUNNER_ID"
    else
      echo "No stale runner named $RUNNER_NAME"
    fi
  '';

  ############################################################
  # Generate a launchd daemon per runner
  ############################################################
  mkRunnerAgent =
    id: runnerCfg:
    let
      runnerName = if runnerCfg.name != null then runnerCfg.name else "nixos-${hostname}-${id}";

      tokenFile = if runnerCfg.tokenFile != null then runnerCfg.tokenFile else cfg.defaultTokenFile;

      inherit (cfg) repo;

      url = if runnerCfg.url != null then runnerCfg.url else "https://github.com/${repo}";

      ephemeral = runnerCfg.ephemeral or true;
    in
    {
      name = "github-runner-${id}";
      value = {
        serviceConfig = {
          ProgramArguments = [
            "/bin/sh"
            "-c"
            ''
              set -eo pipefail

              USER_HOME="$(dscl . -read /Users/$(id -un) NFSHomeDirectory | awk '{print $2}')"
              export HOME="$USER_HOME"

              ${cleanupRunner} ${runnerName} ${tokenFile} ${repo}

              RUNNER_DIR="$HOME/.github-runner/${id}"
              mkdir -p "$RUNNER_DIR"
              cd "$RUNNER_DIR"

              if [ ! -f .runner ]; then
                ${pkgs.github-runner}/bin/config.sh \
                  --unattended \
                  --name ${runnerName} \
                  --url ${url} \
                  --token "$(cat ${tokenFile})" \
                  ${lib.optionalString ephemeral "--ephemeral"}
              fi

              exec ${pkgs.github-runner}/bin/run.sh
            ''
          ];

          RunAtLoad = true;
          KeepAlive = true;

          # EnvironmentVariables = {
          #   HOME = "/var/root";
          # };

          StandardOutPath = "/tmp/github-runner-${id}.log";
          StandardErrorPath = "/tmp/github-runner-${id}.err";
        };
      };
    };

in
{
  ############################################################
  # OPTIONS
  ############################################################

  options.ci.githubRunners = {
    enable = mkEnableOption "GitHub self-hosted runners (darwin)";

    repo = mkOption {
      type = types.str;
      description = "GitHub repo (owner/name).";
    };

    defaultTokenFile = mkOption {
      type = types.path;
      description = "Default GitHub token file.";
    };

    runners = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            url = mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            tokenFile = mkOption {
              type = types.nullOr types.path;
              default = null;
            };

            ephemeral = mkOption {
              type = types.bool;
              default = true;
            };
          };
        }
      );
      default = { };
    };
  };

  ############################################################
  # IMPLEMENTATION (DARWIN ONLY)
  ############################################################

  config = mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isDarwin) {

    environment.systemPackages = [
      pkgs.github-runner
      pkgs.curl
      pkgs.jq
    ];

    ##########################################################
    # launchd daemons (one per runner)
    ##########################################################

    launchd.user.agents = listToAttrs (mapAttrsToList mkRunnerAgent cfg.runners);

    system.activationScripts.fixLaunchAgentPerms.text = ''
      chmod 644 $HOME/Library/LaunchAgents/org.nixos.github-runner-*.plist || true
    '';

  };
}
