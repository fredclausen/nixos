{ pkgs, lib, ... }:
let
  username = "fred";
in
with lib.hm.gvariant;
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;
    };

    mimeApps = {
      enable = true;

      associations.added = {
        "text/html" = [ "firefox.desktop" ];
        "text/plain" = [ "sublime_text.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-terminal-emulator" = [ "ghostty.desktop" ];
        "image/bmp" = [ "org.gnome.gThumb.desktop" ];
        "image/jpeg" = [ "org.gnome.gThumb.desktop" ];
        "image/gif" = [ "org.gnome.gThumb.desktop" ];
        "image/png" = [ "org.gnome.gThumb.desktop" ];
        "image/tiff" = [ "org.gnome.gThumb.desktop" ];
        "image/x-bmp" = [ "org.gnome.gThumb.desktop" ];
        "image/x-ico" = [ "org.gnome.gThumb.desktop" ];
        "image/x-png" = [ "org.gnome.gThumb.desktop" ];
        "image/x-pcx" = [ "org.gnome.gThumb.desktop" ];
        "image/x-tga" = [ "org.gnome.gThumb.desktop" ];
        "image/xpm" = [ "org.gnome.gThumb.desktop" ];
        "image/svg+xml" = [ "org.gnome.gThumb.desktop" ];
        "image/webp" = [ "org.gnome.gThumb.desktop" ];
        "image/jxl" = [ "org.gnome.gThumb.desktop" ];
        "application/x-zerosize" = [ "sublime_text.desktop" ];
      };
      defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "text/plain" = [ "sublime_text.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-terminal-emulator" = [ "ghostty.desktop" ];
        "image/bmp" = [ "org.gnome.gThumb.desktop" ];
        "image/jpeg" = [ "org.gnome.gThumb.desktop" ];
        "image/gif" = [ "org.gnome.gThumb.desktop" ];
        "image/png" = [ "org.gnome.gThumb.desktop" ];
        "image/tiff" = [ "org.gnome.gThumb.desktop" ];
        "image/x-bmp" = [ "org.gnome.gThumb.desktop" ];
        "image/x-ico" = [ "org.gnome.gThumb.desktop" ];
        "image/x-png" = [ "org.gnome.gThumb.desktop" ];
        "image/x-pcx" = [ "org.gnome.gThumb.desktop" ];
        "image/x-tga" = [ "org.gnome.gThumb.desktop" ];
        "image/xpm" = [ "org.gnome.gThumb.desktop" ];
        "image/svg+xml" = [ "org.gnome.gThumb.desktop" ];
        "image/webp" = [ "org.gnome.gThumb.desktop" ];
        "image/jxl" = [ "org.gnome.gThumb.desktop" ];
        "application/x-zerosize" = [ "sublime_text.desktop" ];
      };
    };
  };
}
