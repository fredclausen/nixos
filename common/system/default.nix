{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.pass
      pkgs.wget
      pkgs.git
    ];
  };
}
