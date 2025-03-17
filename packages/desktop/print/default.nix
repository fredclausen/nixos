{ config, pkgs, ... }:
{
  config = {
    # Enable CUPS to print documents.
    services.printing.enable = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
