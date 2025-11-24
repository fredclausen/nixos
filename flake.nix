{
  description = "Fred's NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
      flake-utils,
      nixvim,
      niri,
      ...
    }:

    let
      # centralize username in one place
      user = "fred";
      hmlib = home-manager.lib;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    in
    {
      ##########################################################################
      ## mkSystem — minimal DRY abstraction
      ##########################################################################

      lib.mkSystem =
        {
          hostName,
          hmModules ? [ ],
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs user hmlib;
          };

          modules = [
            ./systems/${hostName}/configuration.nix
            ./modules/common/system.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${user} = {
                # shared HM baseline
                imports = [ ./modules/common/home.nix ] ++ hmModules;
              };

              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  self
                  user
                  hmlib
                  catppuccin
                  apple-fonts
                  nixvim
                  niri
                  ;
              };
            }
          ]
          ++ extraModules;
        };

      ##########################################################################
      ## Actual system definitions — now extremely small
      ##########################################################################

      nixosConfigurations = {
        Daytona = self.lib.mkSystem {
          hostName = "daytona";
          hmModules = [
            ./systems/daytona/home.nix
          ];
        };

        maranello = self.lib.mkSystem {
          hostName = "maranello";
          hmModules = [ ./systems/maranello/home.nix ];
        };
        sdrhub = self.lib.mkSystem "sdrhub";
        acarshub = self.lib.mkSystem {
          hostName = "acarshub";
          hmModules = [ ];
        };

        vdlmhub = self.lib.mkSystem "vdlmhub";
        hfdlhub1 = self.lib.mkSystem {
          hostName = "hfdlhub1";
          hmModules = [ ];
        };

        hfdlhub2 = self.lib.mkSystem {
          hostName = "hfdlhub2";
          hmModules = [ ];
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
              "^dotfiles/.*/.config/fastfetch/.*"
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
