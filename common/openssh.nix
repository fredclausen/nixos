{ config, pkgs, ... }:
{
  config = {
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  };
}
