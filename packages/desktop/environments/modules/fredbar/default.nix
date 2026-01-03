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
      services.swaync.enable = lib.mkForce false;

      programs.fredbar = {
        enable = true;
      };

      programs.fredcal = {
        enable = true;
        server = config.sops.secrets."email/icloud/caldav_server".path;
        password = config.sops.secrets."email/icloud/password".path;
        username = config.sops.secrets."email/icloud/address".path;
        port = 5090;
      };
    };
  };
}
