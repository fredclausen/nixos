{
  description = "Fred's NixOS config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-needsreboot = {
      url = "github:fredclausen/nixos-needsreboot";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      apple-fonts,
      git-hooks,
      nixvim,
      niri,
      darwin,
      ...
    }:

    let
      # centralize username in one place
      user = "fred";
      verbose_name = "Fred Clausen";
      github_email = "43556888+fredclausen@users.noreply.github.com";
      github_signing_key = "F406B080289FEC21";
      hmlib = home-manager.lib;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      lib.mkSystem =
        {
          hostName,
          hmModules ? [ ],
          extraModules ? [ ],
          stateVersion ? "24.11",
          system ? "x86_64-linux",
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              user
              verbose_name
              github_email
              github_signing_key
              hmlib
              system
              stateVersion
              ;
          };

          modules = [
            ./systems-linux/${hostName}/configuration.nix
            ./modules/common/system.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users.${user} = {
                  # shared HM baseline
                  imports = [ ./modules/common/home.nix ] ++ hmModules;
                };

                extraSpecialArgs = {
                  inherit
                    inputs
                    self
                    user
                    verbose_name
                    hmlib
                    github_email
                    github_signing_key
                    catppuccin
                    apple-fonts
                    nixvim
                    niri
                    stateVersion
                    system
                    ;
                };
              };
            }
          ]
          ++ extraModules;
        };

      lib.mkDarwinSystem =
        {
          hostName,
          hmModules ? [ ],
          extraModules ? [ ],
          stateVersion ? "25.05",
          system ? "aarch64-darwin",
        }:
        darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              inputs
              system
              user
              verbose_name
              github_email
              github_signing_key
              hmlib
              stateVersion
              ;
          };

          modules = [
            ./systems-darwin/${hostName}/configuration.nix
            ./modules/common/system.nix
            home-manager.darwinModules.home-manager

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users.${user} = {
                  imports = [ ./modules/common/home.nix ] ++ hmModules;

                  catppuccin = {
                    enable = true;
                    flavor = "mocha";
                    accent = "lavender";
                  };
                };

                extraSpecialArgs = {
                  inherit
                    inputs
                    self
                    system
                    user
                    verbose_name
                    hmlib
                    github_email
                    github_signing_key
                    catppuccin
                    nixvim
                    stateVersion
                    ;
                };
              };

              # Darwin Nix settings
              nix = {
                optimise.automatic = true;
                settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              };
            }
          ]
          ++ extraModules;
        };

      ##########################################################################
      ## System Definitions                                                  ##
      ##########################################################################

      nixosConfigurations = {
        Daytona = self.lib.mkSystem {
          hostName = "daytona";
          hmModules = [
            ./systems-linux/daytona/home.nix
          ];
        };

        maranello = self.lib.mkSystem {
          hostName = "maranello";
          hmModules = [ ./systems-linux/maranello/home.nix ];
        };

        sdrhub = self.lib.mkSystem {
          hostName = "sdrhub";
          hmModules = [ ];
        };

        acarshub = self.lib.mkSystem {
          hostName = "acarshub";
          hmModules = [ ];
        };

        vdlmhub = self.lib.mkSystem {
          hostName = "vdlmhub";
          hmModules = [ ];
        };

        hfdlhub1 = self.lib.mkSystem {
          hostName = "hfdlhub1";
          hmModules = [ ];
        };

        hfdlhub2 = self.lib.mkSystem {
          hostName = "hfdlhub2";
          hmModules = [ ];
        };
      };

      darwinConfigurations = {
        "Freds-MacBook-Pro" = self.lib.mkDarwinSystem {
          hostName = "Freds-MacBook-Pro";
          hmModules = [ ./systems-darwin/Freds-MacBook-Pro/home.nix ];
        };
      };

      ##########################################################################
      ## Pre-commit checks (per system)                                       ##
      ##########################################################################
      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = pkgs.lib.cleanSourceWith {
              src = ./.;
              # deadnix: skip
              filter = path: type: true;
            };

            excludes = [
              "^res/"
              "^./res/"
              "^typos\\.toml$"
              "^speed_tests/.*\\.txt$"
              "^Documents/.*"
              "^.*\\.png$"
              "^.*\\.jpg$"
              "^dotfiles/.config/fastfetch/.*"
              "secrets.yaml"
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

              # deadnix: detect unused variables, dead code
              deadnix = {
                enable = true;
                entry = "${pkgs.deadnix}/bin/deadnix";
                args = [ "--fail" ]; # exit nonzero on findings
                files = "\\.nix$";
              };

              # statix: idiomatic Nix linter
              statix = {
                enable = true;
                entry = "${pkgs.statix}/bin/statix";
                args = [ "check" ];
                files = "\\.nix$";
              };

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
        }
      );

      ##########################################################################
      ## Dev shells (per system, Rust-free)                                   ##
      ##########################################################################
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          inherit (self.checks.${system}.pre-commit-check) shellHook enabledPackages;
        in
        {
          default = pkgs.mkShell {
            # Bring in the hook packages + extra tools
            buildInputs =
              enabledPackages
              ++ (with pkgs; [
                pre-commit
                check-jsonschema
                codespell
                typos
                nixfmt
                nodePackages.markdownlint-cli2
              ]);

            shellHook = ''
              # Run git-hooks.nix setup (creates .pre-commit-config.yaml)
              ${shellHook}

              # Convenience alias
              alias pre-commit="pre-commit run --all-files"
            '';
          };
        }
      );
    };
}
