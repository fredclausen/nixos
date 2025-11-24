{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.environments.modules.pamixer;
in
{
  options.desktop.environments.modules.pamixer = {
    enable = mkOption {
      description = "Enable pamixer.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        pamixer
      ];
    };
  };
}
