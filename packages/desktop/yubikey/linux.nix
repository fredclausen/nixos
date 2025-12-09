{
  services.pcscd.enable = true;

  security = {
    pam.services = {
      # login = {
      #   u2fAuth = true;
      # };
      sudo.u2fAuth = true;
      swaylock.u2fAuth = true;
    };
  };
}
