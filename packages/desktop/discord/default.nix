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
    users.users.${username} = {
      packages = with pkgs; [
        discord
      ];
    };
  };
}
