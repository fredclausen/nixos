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
  cfg = config.desktop.environments.modules.ulauncher;
in
{
  options.desktop.environments.modules.ulauncher = {
    enable = mkOption {
      description = "Enable ulauncher.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.${username} = {
      packages = with pkgs; [
        ulauncher
      ];
    };
  };
}
