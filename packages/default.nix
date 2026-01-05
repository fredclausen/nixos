{
  imports = [
    ./ai
    ./common
    ./desktop
    ./shell
  ];

  config = {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
