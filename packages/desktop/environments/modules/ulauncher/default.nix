{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
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
    users.users.fred = {
      packages = with pkgs; [
        ulauncher
      ];
    };
  };
}
