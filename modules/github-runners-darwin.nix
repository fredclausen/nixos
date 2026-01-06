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
  # Mint a short-lived runner registration token (for config.sh)
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
  #
  # NOTE: On nix-darwin, /nix/store is typically mounted noexec,
  # so launchd must invoke a system interpreter (/bin/sh) rather
  # than exec'ing /nix/store scripts directly.
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

      # Script is "data" (read by /bin/sh), not executed directly by launchd.
      runnerScript = pkgs.writeText "github-runner-${id}.sh" ''
        set -euxo pipefail

        # Force logs no matter what launchd does
        exec >> /tmp/github-runner-${id}.log 2>> /tmp/github-runner-${id}.err

        echo "=== runner ${id} starting at $(date) ==="

        USER_HOME="$(dscl . -read /Users/$(id -un) NFSHomeDirectory | awk '{print $2}')"
        export HOME="$USER_HOME"
        echo "HOME=$HOME"

        # Cleanup stale runner (best effort)
        ${cleanupRunner} ${escapeShellArg runnerName} ${escapeShellArg (toString tokenFile)} ${escapeShellArg repo} || true

        RUNNER_DIR="$HOME/.github-runner/${id}"
        mkdir -p "$RUNNER_DIR"
        cd "$RUNNER_DIR"

        if [ ! -f .runner ]; then
          echo "Minting registration token..."
          REG_TOKEN="$(${mintRegToken} ${escapeShellArg (toString tokenFile)} ${escapeShellArg repo})"

          if [ -z "''${REG_TOKEN:-}" ] || [ "$REG_TOKEN" = "null" ]; then
            echo "ERROR: failed to mint registration token"
            exit 1
          fi

          echo "Configuring runner..."
          ${runnerPkg}/bin/config.sh \
            --unattended \
            --name ${escapeShellArg runnerName} \
            --url ${escapeShellArg url} \
            --token "$REG_TOKEN" \
            ${optionalString ephemeral "--ephemeral"}
        else
          echo "Runner already configured (.runner exists), skipping config."
        fi

        echo "Starting run.sh..."
        exec ${runnerPkg}/bin/run.sh
      '';
    in
    {
      name = "github-runner-${id}";
      value = {
        serviceConfig = {
          ProgramArguments = [
            "/bin/sh"
            "${runnerScript}"
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
