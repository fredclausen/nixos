{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.desktop.onepassword;
in
{
  options.desktop.onepassword = {
    enable = mkOption {
      description = "Enable 1Password.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.users.fred = {
      packages = with pkgs; [
        _1password-gui
      ];
    };
  };
}
