{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
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
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = import ./users/homemanager;
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

        daytona = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/daytona/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = import ./users/homemanager;
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

        maranello = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/maranello/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = import ./users/homemanager;
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
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = import ./users/homemanager;
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

        vm = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/vm/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = import ./users/homemanager;
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

        vm64 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/vm64/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fred = import ./users/homemanager;
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
