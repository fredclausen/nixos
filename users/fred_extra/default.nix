# gui packages that aren't available on arm64 linux
{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        tradingview
        discord
      ];
    };
  };
}
