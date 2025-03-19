{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = {
    home-manager.users.fred = {
      home.packages = with pkgs; [
        oh-my-zsh
        zoxide
      ];

      # Enable Oh-my-zsh
      programs.zsh.oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "history-substring-search"
          "colored-man-pages"
          # "zsh-autosuggestions"
          # "zsh-syntax-highlighting"
          "sudo"
          "copyfile"
          "copybuffer"
          "history"
          "zoxide"
        ];
      };
    };
  };
}
