{
  config = {
    home-manager.users.fred =
      { config, pkgs, ... }:
      {
        home.packages = with pkgs; [
          neovim
          # packages needed for my nvim config to work
          lua51Packages.lua
          lua51Packages.luarocks-nix
          tree-sitter
          # packages needed for lsp
          # rust-analyzer-unwrapped
          bash-language-server
          black
          docker-compose-language-service
          dockerfile-language-server
          eslint_d
          # gitui
          hadolint
          lua-language-server
          luajitPackages.luacheck
          github-markdown-toc-go
          markdownlint-cli2
          marksman
          nodePackages.prettier
          prettierd
          pyright
          ruff
          selene
          shellcheck
          shellharden
          shfmt
          stylua
          taplo
          vscode-langservers-extracted
          vscode-langservers-extracted
          vtsls
          yaml-language-server
          copilot-node-server
          nil
        ];
      };
  };
}
