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
  cfg = config.desktop.music;
  cider2 = import ./cider.nix {
    inherit pkgs;
  };
in
{
  options.desktop.music = {
    # Updated to match the new configuration
    enable = mkOption {
      description = "Enable Music";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.${username} = {
      packages = with pkgs; [
        cider2
      ];
    };
  };
}
