{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # https://github.com/catppuccin/nix
    catppuccin.url = "github:catppuccin/nix";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
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
      apple-fonts,
      ...
    }:
    let
      user = "fred";
      hmlib = home-manager.lib;
    in
    {
      nixosConfigurations = {
        sdrhub = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/sdrhub/configuration.nix
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
                  apple-fonts
                  ;
              };
            }
          ];
        };

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
                  apple-fonts
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
                  apple-fonts
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
                  apple-fonts
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
                  apple-fonts
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
                  apple-fonts
                  ;
              };
            }
          ];
        };

        hfdlhub1 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/hfdlhub1/configuration.nix
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
                  apple-fonts
                  ;
              };
            }
          ];
        };

        hfdlhub2 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs hmlib; };
          modules = [
            ./systems/hfdlhub2/configuration.nix
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
                  apple-fonts
                  ;
              };
            }
          ];
        };
      };
    };
}
