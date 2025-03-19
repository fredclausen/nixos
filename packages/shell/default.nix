{
  imports = [
    ./bat
    ./eza
    ./fastfetch
    ./fd
    ./fzf
    ./lazygit
    ./ohmyzsh
    ./starship
    ./yazi
    ./zoxide
    ./zsh
  ];

  # FIXME: bat and lazygit have a dot file in the dotfiles dir, but the config could not be imported from those files and instead
  # we mirrored it here. Fix this to programmatically import the config from the dotfiles dir.
}
