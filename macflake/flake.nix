{
  description = "Home Manager configuration";
  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    # https://daiderd.com/nix-darwin/manual/
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      darwin,
      catppuccin,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      darwinConfigurations.Freds-MacBook-Pro = darwin.lib.darwinSystem {
        inherit system pkgs inputs;
        specialArgs = { inherit inputs; };

        modules = [
          ./darwin
          ./packages/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.fred.imports = [
                ./home-manager
                catppuccin.homeModules.catppuccin
              ];

              users.fred = {
                catppuccin = {
                  flavor = "mocha";
                  accent = "lavender";
                  enable = true;
                };

                # home.file.".wezterm.lua" = {
                #   source = ../dotfiles/fred/.wezterm_darwin.lua;
                # };
              };
            };
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };

            nix = {
              optimise.automatic = true;
              settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              };
            };
          }
        ];
      };
    };
}
