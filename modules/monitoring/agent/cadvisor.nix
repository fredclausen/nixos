{
  services = {
    #########################################################
    # cAdvisor
    #########################################################
    cadvisor = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = 4567;
    };
  };

  networking.firewall.allowedTCPPorts = [
    4567 # cAdvisor
  ];
}
