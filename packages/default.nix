{
  imports = [
    ./common
    ./desktop
    ./develop
    ./shell
  ];

  config = {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
