{
  config = {
    home-manager.users.fred =
      { config, pkgs, ... }:
      {
        home.packages = with pkgs; [
          lazydocker
        ];

        programs.lazydocker = {
          enable = true;
          settings = {
            gui = {
              nerdFontsVersion = "3";
            };
          };
        };
      };
  };
}
