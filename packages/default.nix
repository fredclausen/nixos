{
  imports = [
    ./ai
    ./common
    ./desktop
    ./develop
    ./shell
  ];

  config = {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
