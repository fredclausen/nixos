{
  pkgs,
  user,
  verbose_name,
  ...
}:
let
  username = user;
  full_name = verbose_name;
in
{
  config = {
    hardware.rtl-sdr.enable = true;
    boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ]; # blacklist this module

    services.udev.packages = [ pkgs.rtl-sdr ]; # (there might be other packages that require udev here too)

    users.users.${username} = {
      isNormalUser = true;
      description = "${full_name}";
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
