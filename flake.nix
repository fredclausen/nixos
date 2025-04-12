{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # https://github.com/catppuccin/nix
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      catppuccin,
      home-manager,
      ...
    }:
    let
      user = "fred";
      hmlib = home-manager.lib;
    in
    {
      nixosConfigurations = {
        nebula = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/nebula/configuration.nix
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = {
                imports = [
                  ./users/homemanager
                  catppuccin.homeModules.catppuccin
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  self
                  user
                  hmlib
                  ;
              };
            }
          ];
        };

        Daytona = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/daytona/configuration.nix
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = {
                imports = [
                  ./users/homemanager
                  catppuccin.homeModules.catppuccin
                ];
              };

              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  self
                  user
                  hmlib
                  catppuccin
                  ;
              };
            }
          ];
        };

        maranello = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/maranello/configuration.nix
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = {
                imports = [
                  ./users/homemanager
                  catppuccin.homeModules.catppuccin
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  self
                  user
                  hmlib
                  ;
              };
            }
          ];
        };

        acarshub = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/acarshub/configuration.nix
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = {
                imports = [
                  ./users/homemanager
                  catppuccin.homeModules.catppuccin
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  self
                  user
                  hmlib
                  ;
              };
            }
          ];
        };

        vdlmhub = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/vdlmhub/configuration.nix
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = {
                imports = [
                  ./users/homemanager
                  catppuccin.homeModules.catppuccin
                ];
              };
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  self
                  user
                  hmlib
                  ;
              };
            }
          ];
        };
      };
    };
}
