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
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      catppuccin,
      home-manager,
      apple-fonts,
      git-hooks,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
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
                  home.file.".gitconfig" = {
                    source = ./dotfiles/fred/.gitconfig;
                  };

                  imports = [
                    ./users/homemanager
                    catppuccin.homeModules.catppuccin
                  ];
                  programs.wezterm = {
                    extraConfig = builtins.readFile ./dotfiles/fred/.wezterm.lua;
                  };

                  programs.alacritty = {
                    settings = (builtins.fromTOML (builtins.readFile ./dotfiles/fred/.config/alacritty.toml));
                  };
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
                  home.file.".gitconfig" = {
                    source = ./dotfiles/fred/.gitconfig;
                  };

                  imports = [
                    ./users/homemanager
                    catppuccin.homeModules.catppuccin
                  ];
                  programs.wezterm = {
                    extraConfig = builtins.readFile ./dotfiles/fred/.wezterm.lua;
                  };
                  programs.alacritty = {
                    settings = (builtins.fromTOML (builtins.readFile ./dotfiles/fred/.config/alacritty.toml));
                  };
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
                  home.file.".gitconfig" = {
                    source = ./dotfiles/fred/.gitconfig;
                  };

                  imports = [
                    ./users/homemanager
                    catppuccin.homeModules.catppuccin
                  ];

                  programs.wezterm = {
                    extraConfig = builtins.readFile ./dotfiles/fred/.wezterm.lua;
                  };
                  programs.alacritty = {
                    settings = (builtins.fromTOML (builtins.readFile ./dotfiles/fred/.config/alacritty.toml));
                  };
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
                  home.file.".gitconfig" = {
                    source = ./dotfiles/fred/.gitconfig;
                  };

                  imports = [
                    ./users/homemanager
                    catppuccin.homeModules.catppuccin
                  ];

                  programs.wezterm = {
                    extraConfig = builtins.readFile ./dotfiles/fred/.wezterm.lua;
                  };
                  programs.alacritty = {
                    settings = (builtins.fromTOML (builtins.readFile ./dotfiles/fred/.config/alacritty.toml));
                  };
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
                  home.file.".gitconfig" = {
                    source = ./dotfiles/fred/.gitconfig;
                  };

                  imports = [
                    ./users/homemanager
                    catppuccin.homeModules.catppuccin
                  ];

                  programs.wezterm = {
                    extraConfig = builtins.readFile ./dotfiles/fred/.wezterm.lua;
                  };
                  programs.alacritty = {
                    settings = (builtins.fromTOML (builtins.readFile ./dotfiles/fred/.config/alacritty.toml));
                  };
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
                  home.file.".gitconfig" = {
                    source = ./dotfiles/fred/.gitconfig;
                  };

                  imports = [
                    ./users/homemanager
                    catppuccin.homeModules.catppuccin
                  ];

                  programs.wezterm = {
                    extraConfig = builtins.readFile ./dotfiles/fred/.wezterm.lua;
                  };
                  programs.alacritty = {
                    settings = (builtins.fromTOML (builtins.readFile ./dotfiles/fred/.config/alacritty.toml));
                  };
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
                  home.file.".gitconfig" = {
                    source = ./dotfiles/fred/.gitconfig;
                  };

                  imports = [
                    ./users/homemanager
                    catppuccin.homeModules.catppuccin
                  ];

                  programs.wezterm = {
                    extraConfig = builtins.readFile ./dotfiles/fred/.wezterm.lua;
                  };
                  programs.alacritty = {
                    settings = (builtins.fromTOML (builtins.readFile ./dotfiles/fred/.config/alacritty.toml));
                  };
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
                  home.file.".gitconfig" = {
                    source = ./dotfiles/fred/.gitconfig;
                  };

                  imports = [
                    ./users/homemanager
                    catppuccin.homeModules.catppuccin
                  ];

                  programs.wezterm = {
                    extraConfig = builtins.readFile ./dotfiles/fred/.wezterm.lua;
                  };
                  programs.alacritty = {
                    settings = (builtins.fromTOML (builtins.readFile ./dotfiles/fred/.config/alacritty.toml));
                  };
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

        checks.pre-commit-check = git-hooks.lib.${system}.run {
          src = pkgs.lib.cleanSourceWith {
            src = ./.;
            filter =
              path: type:
              # keep all files, including dotfiles
              true;
          };

          excludes = [
            "^res/"
            "^./res/"
            "^typos\\.toml$"
            "^speed_tests/.*\\.txt$"
            "^Documents/.*"
            "^.*\\.png$"
            "^.*\\.jpg$"
          ];

          hooks = {
            # Built-in git-hooks.nix hooks
            check-yaml.enable = true;
            end-of-file-fixer.enable = true;
            trailing-whitespace = {
              enable = true;
              entry = "${pkgs.python3Packages.pre-commit-hooks}/bin/trailing-whitespace-fixer";
            };

            mixed-line-ending = {
              enable = true;
              entry = "${pkgs.python3Packages.pre-commit-hooks}/bin/mixed-line-ending";
              args = [ "--fix=auto" ];
            };

            check-executables-have-shebangs.enable = true;
            check-shebang-scripts-are-executable.enable = true;
            black.enable = true;
            flake8.enable = true;
            nixfmt.enable = true;
            hadolint.enable = true;
            shellcheck.enable = true;
            prettier.enable = true;

            # Hooks that need system packages
            codespell = {
              enable = true;
              entry = "${pkgs.codespell}/bin/codespell";
              args = [ "--ignore-words=.dictionary.txt" ];
              files = "\\.([ch]|cpp|rs|py|sh|txt|md|toml|yaml|yml)$";
            };

            check-github-actions = {
              enable = true;
              entry = "${pkgs.check-jsonschema}/bin/check-jsonschema";
              args = [
                "--builtin-schema"
                "github-actions"
              ];
              files = "^\\.github/actions/.*\\.ya?ml$";
              pass_filenames = true;
            };

            check-github-workflows = {
              enable = true;
              entry = "${pkgs.check-jsonschema}/bin/check-jsonschema";
              args = [
                "--builtin-schema"
                "github-workflows"
              ];
              files = "^\\.github/workflows/.*\\.ya?ml$";
              pass_filenames = true;
            };
          };
        };

        devShells.default =
          let
            inherit (self.checks.${system}.pre-commit-check) shellHook enabledPackages;
          in
          pkgs.mkShell {
            # Put your Rust toolchain *after* enabledPackages so it wins in PATH
            buildInputs =

              with pkgs; [
                pre-commit
                check-jsonschema
                codespell
                typos
                nixfmt
                nodePackages.markdownlint-cli2
              ];

            shellHook = ''
              # Run git-hooks.nix setup (creates .pre-commit-config.yaml)
              ${shellHook}

              # Your own extras
              alias pre-commit="pre-commit run --all-files"
              alias xtask="cargo run -p xtask --"
            '';
          };

      }
    );
}
