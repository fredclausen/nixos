{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        pre-commit
        # packages needed for my usual pre-commit plugins to work
        cabal-install
        ghc
      ];
    };
  };
}
