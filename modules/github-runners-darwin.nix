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
  # Delete stale runner by name (PAT is OK for this)
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

    if [ -n "''${RUNNER_ID:-}" ] && [ "$RUNNER_ID" != "null" ]; then
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
  # Mint a short-lived runner registration token (THIS is what
  # config.sh must receive, NOT the PAT).
  ############################################################
  mintRegToken = pkgs.writeShellScript "github-runner-mint-registration-token" ''
    set -euo pipefail

    TOKEN_FILE="$1"
    REPO="$2"

    TOKEN="$(cat "$TOKEN_FILE")"

    ${pkgs.curl}/bin/curl --fail --silent \
      -H "Authorization: token $TOKEN" \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/repos/$REPO/actions/runners/registration-token" \
    | ${pkgs.jq}/bin/jq -r '.token'
  '';

  ############################################################
  # Generate a launchd user agent per runner
  ############################################################
  mkRunnerAgent =
    id: runnerCfg:
    let
      runnerName = if runnerCfg.name != null then runnerCfg.name else "nixos-${hostname}-${id}";

      tokenFile = if runnerCfg.tokenFile != null then runnerCfg.tokenFile else cfg.defaultTokenFile;

      inherit (cfg) repo;

      url = if runnerCfg.url != null then runnerCfg.url else "https://github.com/${repo}";

      ephemeral = runnerCfg.ephemeral or true;

      runnerPkg = pkgs.github-runner;

      # runner state lives under the user's HOME so launchd user agents behave
      runnerDirRel = ".github-runner/${id}";
    in
    {
      name = "github-runner-${id}";
      value = {
        serviceConfig = {
          ProgramArguments = [
            "/bin/sh"
            "-c"
            ''
              set -euo pipefail

              # launchd user agents often have a garbage HOME; set it explicitly.
              USER_HOME="$(dscl . -read /Users/$(id -un) NFSHomeDirectory | awk '{print $2}')"
              export HOME="$USER_HOME"

              # Best-effort cleanup (PAT is ok here)
              ${cleanupRunner} ${escapeShellArg runnerName} ${escapeShellArg (toString tokenFile)} ${escapeShellArg repo} || true

              RUNNER_DIR="$HOME/${runnerDirRel}"
              mkdir -p "$RUNNER_DIR"
              cd "$RUNNER_DIR"

              # Only configure once (config.sh writes .runner on success)
              if [ ! -f .runner ]; then
                echo "Minting registration token for ${repo}..."
                REG_TOKEN="$(${mintRegToken} ${escapeShellArg (toString tokenFile)} ${escapeShellArg repo})"

                if [ -z "''${REG_TOKEN:-}" ] || [ "$REG_TOKEN" = "null" ]; then
                  echo "ERROR: failed to mint runner registration token"
                  exit 1
                fi

                echo "Configuring runner ${runnerName}..."
                ${runnerPkg}/bin/config.sh \
                  --unattended \
                  --name ${escapeShellArg runnerName} \
                  --url ${escapeShellArg url} \
                  --token "$REG_TOKEN" \
                  ${optionalString ephemeral "--ephemeral"}
              fi

              echo "Starting runner ${runnerName}..."
              exec ${runnerPkg}/bin/run.sh
            ''
          ];

          RunAtLoad = true;
          KeepAlive = true;

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
      description = "GitHub repo (owner/name) runners register to.";
    };

    defaultTokenFile = mkOption {
      type = types.path;
      description = "Default GitHub PAT token file path (used to mint runner reg tokens).";
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

    launchd.user.agents = listToAttrs (mapAttrsToList mkRunnerAgent cfg.runners);
  };
}
