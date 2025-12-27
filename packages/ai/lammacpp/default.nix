{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.ai.local-llm;
in
{
  options.ai.local-llm = {
    enable = mkEnableOption "Enable local LLM stack (Ollama + Open WebUI)";

    ollamaPort = mkOption {
      type = types.port;
      default = 11434;
      description = "Port for Ollama API";
    };

    webuiPort = mkOption {
      type = types.port;
      default = 8080;
      description = "Port for Open WebUI";
    };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Bind address for services";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.ollama
      pkgs.open-webui
    ];

    users.users.ollama = {
      isSystemUser = true;
      home = "/var/lib/ollama";
      createHome = true;
      group = "ollama";
    };

    users.groups.ollama = { };

    # Ollama backend (model manager + runtime)
    systemd.services.ollama = {
      description = "Ollama LLM runtime";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.ollama}/bin/ollama serve";

        Restart = "always";
        RestartSec = 3;

        # Run as dedicated user
        User = "ollama";
        Group = "ollama";

        # Ollama *requires* HOME
        Environment = [
          "HOME=/var/lib/ollama"
          "OLLAMA_MODELS=/var/lib/ollama/models"
          "OLLAMA_HOST=127.0.0.1:11434"
        ];

        WorkingDirectory = "/var/lib/ollama";

        StateDirectory = "ollama";
        StateDirectoryMode = "0755";

        LimitNOFILE = 1048576;
      };
    };

    # Open WebUI frontend (web model manager UI + OpenAI proxy)
    systemd.services.open-webui = {
      description = "Open WebUI (UI for Ollama)";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "ollama.service"
      ];
      requires = [ "ollama.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
        Restart = "always";
        RestartSec = 3;

        Environment = [
          # Tell Open WebUI to use Ollama
          "OLLAMA_BASE_URL=http://127.0.0.1:${toString cfg.ollamaPort}"
          # Auth off for local use (you can turn this on later)
          "WEBUI_AUTH=false"
          "ENABLE_SIGNUP=false"
          # Persist state in /var/lib (not nix store)
          "DATA_DIR=/var/lib/open-webui"
          # Bind/port: Open WebUI may still default to 8080 depending on packaging,
          # but we'll set the conventional envs anyway:
          "HOST=${cfg.host}"
          "PORT=${toString cfg.webuiPort}"
        ];

        StateDirectory = "open-webui";
        WorkingDirectory = "/var/lib/open-webui";

        LimitNOFILE = 1048576;
        MemoryMax = "0";
      };
    };
  };
}
