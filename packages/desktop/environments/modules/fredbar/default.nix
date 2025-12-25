{
  lib,
  config,
  user,
  ...
}:
with lib;
let
  username = user;
  cfg = config.desktop.environments.modules.fredbar;
in
{
  options.desktop.environments.modules.fredbar = {
    enable = mkOption {
      description = "Enable fredbar.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.fredbar = {
        enable = true;
      };
    };
  };
}
