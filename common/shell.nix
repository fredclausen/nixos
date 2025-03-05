{ config, pkgs, ... }:
{
  config = {
    programs.zsh.enable = true;
    programs.bash.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.defaultUserShell = pkgs.zsh;
  };
}
