{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.sublimetext;
in
{
  options.desktop.sublimetext = {
    enable = mkOption {
      description = "Enable Sublime Text.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        sublime4
      ];
    };
  };
}
