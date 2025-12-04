{
  #########################################################
  # Node Exporter (runs on every node)
  #########################################################
  services = {
    prometheus.exporters.node = {
      enable = true;
      openFirewall = true;
      listenAddress = "0.0.0.0";
      port = 9100;
    };

    #########################################################
    # cAdvisor
    #########################################################
    cadvisor = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = 4567;
    };
  };

  #########################################################
  # (Optional future expansions)
  # - systemd exporter
  # - docker exporter
  # - github-runner exporter
  # - custom pushgateway metrics
  #########################################################

  #######################################
  # Firewall
  #######################################
  networking.firewall.allowedTCPPorts = [
    9090 # Prometheus
    9093 # Alertmanager
    3333 # Grafana
    4567 # cAdvisor
  ];
}
