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
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "fred" ];
    };
  };
}
