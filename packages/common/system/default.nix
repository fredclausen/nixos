{ config, pkgs, ... }:
{
  config = {

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable networking
    networking.networkmanager.enable = true;

    environment.systemPackages = [
      pkgs.pass
      pkgs.wget
      pkgs.git
      pkgs.unzip
      pkgs.file
      pkgs.lsd
      pkgs.zip
      pkgs.btop
      pkgs.toybox
      pkgs.nix-index
      pkgs.lm_sensors
      pkgs.dig
      pkgs.nethogs
    ];

    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };
    nix.settings.auto-optimise-store = true;
    services.fwupd.enable = true;

    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    security.polkit.enable = true;
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      })
    '';

    home-manager.users.fred = {
      programs.btop = {
        enable = true;
      };
      catppuccin.btop.enable = true;

      programs.git = {
        enable = true;
        userName = "Fred Clausen";
        userEmail = "43556888+fredclausen@users.noreply.github.com";

        diff-so-fancy.enable = true;
        signing = {
          signer = "${pkgs.gnupg}/bin/gpg";
          signByDefault = true;
          key = "F406B080289FEC21";
        };

        extraConfig = {
          "credential \"https://github.com\"" = {
            helper = "!/etc/profiles/per-user/fred/bin/gh auth git-credential";
          };
          "credential \"https://gist.github.com\"" = {
            helper = "!/etc/profiles/per-user/fred/bin/gh auth git-credential";
          };
        };

        lfs = {
          enable = true;
          skipSmudge = false;
        };
      };
    };
  };
}
