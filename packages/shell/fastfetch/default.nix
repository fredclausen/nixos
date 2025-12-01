{
  pkgs,
  user,
  ...
}:

let
  username = user;
in
{
  config = {
    home-manager.users.${username} = {

      home.packages = [ pkgs.fastfetch ];

      programs.fastfetch = {
        enable = true;

        settings = {
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

          modules = [
            "title"
            "separator"
            "os"

            {
              type = "host";
              format = "{/2}{-}{/}{2}{?3} {3}{?}";
            }

            "kernel"
            "uptime"

            {
              type = "battery";
              format = "{/4}{-}{/}{4}{?5} [{5}]{?}";
            }

            "break"
            "packages"
            "shell"
            "display"
            "terminal"
            "break"
            "cpu"

            {
              type = "gpu";
              key = "GPU";
            }

            "memory"
            "break"
            "colors"
          ];
        };
      };

    };
  };
}
