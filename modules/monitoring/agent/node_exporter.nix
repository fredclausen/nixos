{
  services = {
    #########################################################
    # Node Exporter
    #########################################################
    prometheus.exporters.node = {
      enable = true;
      openFirewall = true;
      listenAddress = "0.0.0.0";
      port = 9100;
    };
  };

  networking.firewall.allowedTCPPorts = [
    9100 # node_exporter
  ];
}
