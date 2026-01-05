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

  # Cleanup helper: delete runner by name before (re)registering
  cleanupRunner = pkgs.writeShellScriptBin "github-runner-cleanup" ''
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
      | ${pkgs.jq}/bin/jq -r --arg NAME "$RUNNER_NAME" '
          .runners[] | select(.name == $NAME) | .id
        '
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

  # Construct a github-runners entry
  mkRunner =
    name: runnerCfg:
    let
      finalName = if runnerCfg.name != null then runnerCfg.name else "nixos-${hostname}-${name}";
      finalTokenFile = runnerCfg.tokenFile or cfg.defaultTokenFile;

      finalUrl = runnerCfg.url or "https://github.com/${cfg.repo}";
    in
    {
      inherit name;
      value = {
        enable = true;
        name = finalName;
        url = finalUrl;
        tokenFile = finalTokenFile;
        inherit (runnerCfg) ephemeral;
      };
    };

in
{
  ###### OPTIONS ######

  options.ci.githubRunners = {
    enable = mkEnableOption "GitHub self-hosted runners with cleanup";

    repo = mkOption {
      type = types.str;
      example = "FredSystems/nixos";
      description = "GitHub repo (owner/name) runners are registered to.";
    };

    defaultTokenFile = mkOption {
      type = types.path;
      description = "Default GitHub token file path.";
    };

    runners = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Explicit runner name (defaults to nixos-<host>-<id>).";
            };

            url = mkOption {
              type = types.str;
              description = "GitHub repository URL.";
            };

            tokenFile = mkOption {
              type = types.path;
              description = "Token file used to register this runner.";
            };

            ephemeral = mkOption {
              type = types.bool;
              default = true;
              description = "Whether the runner is ephemeral.";
            };
          };
        }
      );
      default = { };
      description = "GitHub runners keyed by logical ID (e.g. runner-1).";
    };
  };

  ###### IMPLEMENTATION ######

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.curl
      pkgs.jq
    ];

    # Generate services.github-runners entries
    services.github-runners = listToAttrs (mapAttrsToList mkRunner cfg.runners);

    # Inject cleanup logic into systemd units
    systemd.services = foldl' (
      acc: r:
      let
        runnerName = r.value.name;
        svcName = "github-runner-${runnerName}";
      in
      acc
      // {
        ${svcName} = {
          serviceConfig = {
            ExecStartPre = [
              "${cleanupRunner}/bin/github-runner-cleanup ${runnerName} ${r.value.tokenFile} ${cfg.repo}"
            ];
            Restart = "always";
            RestartSec = 5;
            OOMPolicy = "restart";
          };
        };
      }
    ) { } (mapAttrsToList mkRunner cfg.runners);
  };
}
