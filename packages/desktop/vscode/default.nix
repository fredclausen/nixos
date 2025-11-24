{
  lib,
  pkgs,
  config,
  user,
  ...
}:
with lib;
let
  username = user;
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
    users.users.${username} = {
      packages = with pkgs; [
        vscode
      ];
    };
  };
}
