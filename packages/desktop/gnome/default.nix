{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.gnomeExtensions.caffeine
      pkgs.gnomeExtensions.vitals
      pkgs.gnomeExtensions.impatience
      pkgs.gnomeExtensions.clipboard-indicator
      pkgs.gnomeExtensions.dash-to-panel
      pkgs.gnomeExtensions.arcmenu
      pkgs.gnomeExtensions.search-light
      pkgs.gnomeExtensions.weather-or-not
      pkgs.flat-remix-gnome
      pkgs.wl-clipboard
      pkgs.dconf-editor
      pkgs.gthumb
      pkgs.gimp
      pkgs.sushi
    ];

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = (
      with pkgs;
      [
        atomix # puzzle game
        cheese # webcam tool
        epiphany # web browser
        gnome-characters
        gnome-music
        gnome-photos
        gnome-tour
        hitori # sudoku game
        iagno # go game
        tali # poker game
        totem # video player
      ]
    );
  };
}
