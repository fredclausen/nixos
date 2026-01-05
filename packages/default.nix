{
  imports = [
    ./ai
    ./common
    ./desktop
    ./media
    ./shell
  ];

  config = {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
