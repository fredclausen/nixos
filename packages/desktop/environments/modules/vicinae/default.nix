{
  lib,
  config,
  user,
  ...
}:
with lib;
let
  username = user;
  cfg = config.desktop.environments.modules.vicinae;
in
{
  options.desktop.environments.modules.vicinae = {
    enable = mkOption {
      description = "Enable vicinae.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.vicinae = {
        enable = true;
        systemd = {
          enable = true;
        };
      };
      catppuccin.vicinae.enable = true;
    };
  };
}
