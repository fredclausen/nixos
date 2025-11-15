{
  config = {
    home-manager.users.fred =
      { config, pkgs, ... }:
      {
        programs.tmux = {
          enable = true;
          clock24 = true;
        };
      };
  };
}
