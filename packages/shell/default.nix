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
      source = ../../dotfiles/${username}/.config/scripts;
      recursive = true;
    };

    home.file.".config/hadolint.yaml" = {
      source = ../../dotfiles/${username}/.config/hadolint.yaml;
    };

    home.file.".markdownlint-cli2.yaml" = {
      source = ../../dotfiles/${username}/.markdownlint-cli2.yaml;
    };
  };

  # FIXME: bat have a dot file in the dotfiles dir, but the config could not be imported from those files and instead
  # we mirrored it here. Fix this to programmatically import the config from the dotfiles dir.
  # lazygit was fixed, but I'm not sure bat can be fixed. nix seems to add some extra stuff to the config (namely --map-syntax for ghostty)
  # that seems kinda cool. I suppose we could just add in to the dotfile config, but if it's willing to map that in, who knows what other cool
  # stuff would be added in the future with other/new packages.
}
