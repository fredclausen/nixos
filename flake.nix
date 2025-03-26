{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-cosmic,
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
            nixos-cosmic.nixosModules.default
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
            nixos-cosmic.nixosModules.default
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
