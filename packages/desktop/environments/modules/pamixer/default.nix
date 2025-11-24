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
    users.users.${username} = {
      packages = with pkgs; [
        pamixer
      ];
    };
  };
}
