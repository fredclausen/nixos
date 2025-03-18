{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.vscode;
in
{
  options.desktop.vscode = {
    enable = mkOption {
      description = "Enable Visual Studio Code.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        vscode
      ];
    };
  };
}
