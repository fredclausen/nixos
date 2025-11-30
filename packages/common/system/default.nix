{
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = {

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable networking
    networking.networkmanager.enable = true;

    nixpkgs.overlays = [
      (final: prev: {
        nixos-needsreboot = prev.nixos-needsreboot.overrideAttrs (old: {
          vendorSha256 = "sha256-o4/q0t9GhPbZ+R4Rnxf202WMJcMNu4RftqHkS95YZJs=";
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      pass
      wget
      unzip
      file
      lsd
      zip
      toybox
      nix-index
      lm_sensors
      dig
      nethogs
      inotify-tools
      usbutils
      hwdata
      airspy
      inputs.nixos-needsreboot.packages.${config.nixpkgs.hostPlatform.system}.default
    ];

    services.udev.packages = with pkgs; [
      airspy
    ];

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

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
  };
}
