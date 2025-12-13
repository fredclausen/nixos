{
  lib,
  pkgs,
  config,
  user,
  system,
  ...
}:
with lib;
let
  cfg = config.desktop.yubikey;
  username = user;
  isDarwin = lib.hasSuffix "darwin" system;
  isLinux = !isDarwin;
in
{
  options.desktop.yubikey = {
    enable = mkOption {
      description = "Install Yubikey Manager.";
      default = false;
    };
  };

  imports = lib.optional isLinux ./linux.nix ++ lib.optional isDarwin ./mac.nix;

  config = mkIf cfg.enable {
    # security = {
    # pam.services = {
    #   # login = {
    #   #   u2fAuth = true;
    #   # };
    #   sudo.u2fAuth = true;
    #   swaylock.u2fAuth = true;
    # };

    # pam.yubico = {
    #   enable = true;
    #   debug = true;
    #   mode = "challenge-response";
    #   id = [ "13380413" ];
    # };
    # };

    home-manager.users.${username} = {
      services.yubikey-agent.enable = true;

      programs.gpg = {
        enable = true;
        settings = {
          "no-tty" = true;
        };

        scdaemonSettings = {
          disable-ccid = true;
        };
      };
    };

    users.users.${username} = {
      packages = with pkgs; [
        pam_u2f
        yubioath-flutter
        yubico-piv-tool
      ];
    };
  };
}
