{ config, pkgs, ... }:
{
  config = {
    hardware.rtl-sdr.enable = true;
    boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ]; # blacklist this module

    services.udev.packages = [ pkgs.rtl-sdr ]; # (there might be other packages that require udev here too)

    home-manager.users.fred =
      { config, pkgs, ... }:
      {
        home.file."./.config/nvim".source =
          config.lib.file.mkOutOfStoreSymlink "/home/fred/GitHub/nixos/dotfiles/fred/.config/nvim";
      };

    users.users.fred = {
      isNormalUser = true;
      description = "Fred Clausen";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "plugdev"
        "wireshark"
      ];

      packages = with pkgs; [
        gh
        stow
        rtl-sdr-librtlsdr
        rrdtool
        # dconf2nix don't want but for now we'll leave it commented out. Useful to dump dconf settings to nix, but the nix package is old and broke
      ];
    };
  };
}
