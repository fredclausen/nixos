{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.ci.githubRunners;

  # Best-effort default: first non-root declared user, else "root".
  defaultUser =
    let
      names = builtins.attrNames (config.users.users or { });
      nonRoot = builtins.filter (n: n != "root") names;
    in
    if nonRoot != [ ] then builtins.head nonRoot else "root";

  hostname = config.networking.hostName;

  ############################################################
  # Delete stale runner by name (PAT is OK for this)
  ############################################################
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
  mintRegToken = pkgs.writeShellScriptBin "github-runner-mint-registration-token" ''
    set -euo pipefail

    TOKEN_FILE="$1"
    REPO="$2"

    TOKEN="$(cat "$TOKEN_FILE")"

    echo "Using $TOKEN $REPO"

    ${pkgs.curl}/bin/curl --fail --silent \
      -H "Authorization: token $TOKEN" \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/repos/$REPO/actions/runners/registration-token" \
    | ${pkgs.jq}/bin/jq -r '.token'
  '';

  ############################################################
  # One LaunchDaemon per runner (runs as cfg.user)
  ############################################################
  mkRunnerDaemon =
    id: runnerCfg:
    let
      runnerName = if runnerCfg.name != null then runnerCfg.name else "nixos-${hostname}-${id}";

      tokenFile = if runnerCfg.tokenFile != null then runnerCfg.tokenFile else cfg.defaultTokenFile;

      inherit (cfg) repo;

      url = if runnerCfg.url != null then runnerCfg.url else "https://github.com/${repo}";

      ephemeral = runnerCfg.ephemeral or true;

      runnerPkg = pkgs.github-runner;

      runnerScript = pkgs.writeShellScriptBin "github-runner-${id}" ''
        # set -euo pipefail

        echo "=== runner ${id} starting at $(date) ==="

        # Ensure HOME is correct even if launchd hands us something odd.
        USER_HOME="/Users/fred"
        #USER_HOME="$(dscl . -read /Users/${escapeShellArg cfg.user} NFSHomeDirectory | ${pkgs.gawk}/bin/awk '{print $2}')"
        export HOME="$USER_HOME"
        echo "HOME=$HOME"

        # Best-effort cleanup of stale runner registration
        ${cleanupRunner}/bin/github-runner-cleanup \
          ${escapeShellArg runnerName} \
          ${escapeShellArg (toString tokenFile)} \
          ${escapeShellArg repo} || true

        RUNNER_DIR="$HOME/.github-runner/${id}"
        mkdir -p "$RUNNER_DIR"
        cd "$RUNNER_DIR"

        if [ ! -f .runner ]; then
          echo "Minting registration token..."
          REG_TOKEN="$(${mintRegToken}/bin/github-runner-mint-registration-token ${escapeShellArg (toString tokenFile)} ${escapeShellArg repo})"

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
            "-lc"
            "${runnerScript}/bin/github-runner-${id}"
          ];

          RunAtLoad = true;
          # KeepAlive = true;

          # Run as your user so runner state lives in your HOME.
          # UserName = cfg.user;

          StandardOutPath = "/Users/fred/github-runner-${id}.log";
          StandardErrorPath = "/Users/fred/github-runner-${id}.err";
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

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = "macOS username to run the runner under.";
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
      pkgs.gawk
    ];

    # System domain avoids the LaunchAgent/BTM "sh" nonsense.
    launchd.user.agents = listToAttrs (mapAttrsToList mkRunnerAgent cfg.runners);
  };
}
