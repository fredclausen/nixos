{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.discord;
in
{
  options.desktop.discord = {
    enable = mkOption {
      description = "Enable Discord.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        discord
      ];
    };
  };
}
