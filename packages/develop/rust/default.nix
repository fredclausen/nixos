{ config, pkgs, ... }:
{
  config = {
    users.users.fred = {
      packages = with pkgs; [
        # add cargo and rustup to the path
        # this is needed for the rust-analyzer language server
        # you should definitely use `nix develop` flake in a project
        # cargo
        rustup
      ];
    };
  };
}
