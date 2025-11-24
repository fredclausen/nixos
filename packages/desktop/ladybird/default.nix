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
  cfg = config.desktop.ladybird;
in
{
  options.desktop.ladybird = {
    enable = mkOption {
      description = "Install Ladybird browser.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.${username} = {
      packages = with pkgs; [
        ladybird
      ];
    };
  };
}
