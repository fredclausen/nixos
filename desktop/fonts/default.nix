{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.nerdfonts
      pkgs.fira-code
      pkgs.fira-code-symbols
    ];
  };
}
