{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        neovim
        # packages needed for my nvim config to work
        lua51Packages.lua
        luajitPackages.luarocks_bootstrap
        tree-sitter
      ];
    };
  };
}
