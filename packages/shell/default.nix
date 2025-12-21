{ user, ... }:
let
  username = user;
in
{
  imports = [
    ./bat
    ./direnv
    ./eza
    ./fastfetch
    ./fd
    ./fzf
    ./gh-dash
    ./lazydocker
    ./lazygit
    ./lsd
    ./ohmyzsh
    # FIXME: pay respects appears to be fucked. It kills the terminal
    ./pay-respects
    ./starship
    ./tmux
    ./yazi
    ./zoxide
    ./zsh
  ];

  home-manager.users.${username} = {
    home.file.".config/scripts/" = {
      source = ../../dotfiles/.config/scripts;
      recursive = true;
    };

    home.file.".markdownlint-cli2.yaml" = {
      source = ../../dotfiles/.markdownlint-cli2.yaml;
    };
  };
}
