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
        lazygit
      ];

      programs.lazygit = {
        enable = true;
        # settings = {
        #   gui = {
        #     nerdFontsVersion = "3";
        #     theme = {
        #       activeBorderColor = [
        #         "#a6d189"
        #         "bold"
        #       ];
        #       inactiveBorderColor = [ "#a5adce" ];
        #       optionsTextColor = [ "#8caaee" ];
        #       selectedLineBgColor = [ "#414559" ];
        #       cherryPickedCommitBgColor = [ "#51576d" ];
        #       cherryPickedCommitFgColor = [ "#a6d189" ];
        #       unstagedChangesColor = [ "#e78284" ];
        #       defaultFgColor = [ "#c6d0f5" ];
        #       searchingActiveBorderColor = [ "#e5c890" ];
        #       #   authorColors = [
        #       #     "Fred Clausen" = ["blue"]
        #       #   ]
        #     };
        #   };
        # };
      };

      xdg.configFile = {
        "lazygit/config.yml".source = ../../../dotfiles/fred/.config/lazygit/config.yml;
      };
    };
  };
}
