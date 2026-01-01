{
  lib,
  pkgs,
  config,
  user,
  ...
}:
with lib;
let
  username = user;
  cfg = config.desktop.zed;
in
{
  options.desktop.zed = {
    enable = mkOption {
      description = "Enable Zed.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets.openai_api = {
      owner = config.users.users.${username}.name;
    };

    home-manager.users.${username} = {
      # install packages
      home.packages = with pkgs; [
        (pkgs.writeShellScriptBin "zed" ''
          set -a
          source ${config.sops.secrets.openai_api.path}
          set +a
          exec ${pkgs.zed-editor}/bin/zeditor "$@"
        '')
        vtsls
        # custom wrapper that feels bad but makes lsp work
        (pkgs.writeShellScriptBin "vtsls-local" ''
          exec ${lib.getExe pkgs.vtsls} --stdio
        '')
        ruff
        (pkgs.writeShellScriptBin "ruff-local" ''
          exec ${lib.getExe pkgs.ruff} server
        '')
        shellcheck
        bash-language-server
        (pkgs.writeShellScriptBin "bash-language-server-local" ''
          exec ${lib.getExe pkgs.bash-language-server} start
        '')
        shfmt
        dockerfile-language-server
        (pkgs.writeShellScriptBin "dockerfile-language-server-local" ''
          exec ${lib.getExe pkgs.dockerfile-language-server} --stdio
        '')
        ansible-lint
        crates-lsp
        vscode-json-languageserver
        (pkgs.writeShellScriptBin "jsonls-local" ''
          exec ${lib.getExe pkgs.vscode-json-languageserver} --stdio
        '')
        package-version-server
        lua-language-server
      ];
      catppuccin.zed = {
        enable = true;
        icons.enable = true;
        italics = true;
      };
      programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
          "toml"
          "tombi"
          "rust"
          "python"
          "markdown"
          "yaml"
          "basher"
          "dockerfile"
          "scss"
          "lua"
          "ini"
          "ansible"
          "crates-lsp"
          "json"
          "json5"
          "css"
          "markdown"
          "markdownlint"
          "git-firefly"
          "xml"
        ];
        userSettings = {
          # theme = {
          #   mode = "system";
          #   dark = "One Dark";
          #   light = "One Light";
          # };
          hour_format = "hour24";
          # vim_mode = true;
          # Tell Zed to use direnv and direnv can use a flake.nix environment
          load_direnv = "shell_hook";
          base_keymap = "VSCode";
          show_whitespaces = "all";
          ui_font_size = 14;
          buffer_font_size = 14;

          assistant = {
            enabled = true;
            version = "2";

            default_open_ai_model = "qwen2.5-coder:7b";

            # Provider options:
            # - zed.dev models (claude-3-5-sonnet-latest) requires GitHub connected
            # - anthropic models (claude-3-5-sonnet-latest, claude-3-haiku-latest, claude-3-opus-latest) requires API_KEY
            # - copilot_chat models (gpt-4o, gpt-4, gpt-3.5-turbo, o1-preview) requires GitHub connected
            inline_alternatives = [
              {
                provider = "copilot_chat";
                model = "gpt-4o";
              }
              {
                provider = "openai";
                model = "qwen2.5-coder:7b";
              }
              {
                provider = "zed.dev";
                model = "claude-3-5-sonnet-latest";
              }
              {
                provider = "openai";
                model = "gpt-4o";
              }
            ];

            default_model = {
              provider = "copilot_chat";
              model = "gpt-4o";
            };
          };

          agent = {
            default_model = {
              provider = "copilot_chat";
              model = "gpt-4o";
            };
          };

          openai = {
            # Local LLM (Ollama)
            api_base = "http://localhost:11434/v1";
            api_key = "local"; # Ollama ignores this, Zed requires it to exist
          };

          github_copilot = {
            enabled = true;
          };

          file_types = {
            Ansible = [
              # This is super bespoke to me. If someone else is using my stuff
              # you will need to play with this
              "**/modules/ansible/plays/*.yaml"
            ];
          };

          node = {
            path = lib.getExe pkgs.nodejs;
            npm_path = lib.getExe' pkgs.nodejs "npm";
          };

          terminal = {
            alternate_scroll = "off";
            blinking = "off";
            copy_on_select = false;
            dock = "bottom";
            detect_venv = {
              on = {
                directories = [
                  ".env"
                  "env"
                  ".venv"
                  "venv"
                ];
                activate_script = "default";
              };
            };
            env = {
              TERM = "wezterm";
            };
            font_family = "FiraCode Nerd Font";
            font_features = null;
            font_size = null;
            line_height = "comfortable";
            option_as_meta = false;
            button = false;
            shell = "system";
            toolbar = {
              title = true;
            };
            working_directory = "current_project_directory";
          };

          languages = {
            CSS = {
              tab_size = 2;
              formatter = "prettier";
            };
            SCSS = {
              tab_size = 2;
              formatter = "prettier";
            };
            JSON = {
              tab_size = 2;
              formatter = "prettier";
            };
            YAML = {
              tab_size = 2;
            };
            Markdown = {
              tab_size = 2;
            };
          };

          lsp = {
            rust-analyzer = {
              binary = {
                path = lib.getExe pkgs.rust-analyzer;
                #path_lookup = true;
              };
              settings = {
                diagnostics = {
                  enable = true;
                  styleLints = {
                    enable = true;
                  }; # Corrected styleLints access
                };
                checkOnSave = true;
                check = {
                  command = "clippy";
                  features = "all";
                };
                cargo = {
                  buildScripts = {
                    enable = true;
                  }; # Corrected buildScripts access
                  features = "all";
                };
                inlayHints = {
                  bindingModeHints = {
                    enable = true;
                  }; # Corrected access
                  closureStyle = "rust_analyzer";
                  closureReturnTypeHints = {
                    enable = "always";
                  }; # Corrected access
                  discriminantHints = {
                    enable = "always";
                  }; # Corrected access
                  expressionAdjustmentHints = {
                    enable = "always";
                  }; # Corrected access
                  implicitDrops = {
                    enable = true;
                  };
                  lifetimeElisionHints = {
                    enable = "always";
                  }; # Corrected access
                  rangeExclusiveHints = {
                    enable = true;
                  };
                };
                procMacro = {
                  enable = true;
                };
                rustc = {
                  source = "discover";
                };
                files = {
                  excludeDirs = [
                    ".cargo"
                    ".direnv"
                    ".git"
                    "node_modules"
                    "target"
                  ];
                };
              };
            };

            crates-lsp = {
              binary = {
                path = lib.getExe pkgs.crates-lsp;
              };
            };

            Nix = {
              language_servers = [
                "nixd"
                "!nil"
              ];
            };

            nixd = {
              binary = {
                path = lib.getExe pkgs.nixd;
              };
            };

            # I don't think we're using this, but it shuts up errors
            nil = {
              binary = {
                path = lib.getExe pkgs.nil;
              };

              settings = {
                nix = {
                  flake = {
                    autoArchive = true;
                  };
                };
              };
            };

            # typescript lsp
            vtsls = {
              binary = {
                path = "/etc/profiles/per-user/fred/bin/vtsls-local";
              };
              args = [ "--stdio" ];
            };

            python = {
              language_servers = [
                "!ruff"
                "pyright"
              ];
            };

            # python lsp
            ruff = {
              binary = {
                path = "/etc/profiles/per-user/fred/bin/ruff-local";
              };
            };

            bash = {
              language_servers = [
                "bash-language-server"
              ];
            };

            bash-language-server = {
              binary = {
                path = "/etc/profiles/per-user/fred/bin/bash-language-server-local";
              };
            };

            shellcheck = {
              binary = {
                path = lib.getExe pkgs.shellcheck;
              };
            };

            shfmt = {
              binary = {
                path = lib.getExe pkgs.shfmt;
              };
            };

            dockerfile-language-server = {
              binary = {
                path = "/etc/profiles/per-user/fred/bin/dockerfile-language-server-local";
              };
            };

            markdownlint = {
              settings = {
                "MD013" = false; # line length
                "MD033" = false; # inline HTML
              };
            };
          };
        };
      };
    };
  };
}
