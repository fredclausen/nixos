{
  lib,
  config,
  user,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  username = user;
  cfg = config.desktop.environments.modules.ags;
in
{
  options.desktop.environments.modules.ags = {
    enable = mkOption {
      description = "Enable ags.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.ags = {
        enable = true;

        # symlink to ~/.config/ags
        configDir = ./config;

        # additional packages and executables to add to gjs's runtime
        extraPackages = with pkgs; [
          inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
          inputs.astal.packages.${pkgs.stdenv.hostPlatform.system}.tray
          # inputs.astal.packages.${pkgs.system}.battery
          # fzf
        ];
      };
    };
  };
}
