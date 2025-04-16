{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
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
    users.users.fred = {
      packages = with pkgs; [
        cider2
      ];
    };
  };
}
