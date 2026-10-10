{
  flake.modules.nixos.victoriametrics =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        let
          exporterCfg = config.services.prometheus.exporters;
        in
        {
          services.victoriametrics = {
            enable = true;
            listenAddress = "127.0.0.1:${toString config.profile.services.victoriametrics.port}";
            retentionPeriod = "90d";
          };
          services.vmagent = {
            enable = true;
            remoteWrite.url = "http://${config.services.victoriametrics.listenAddress}/api/v1/write";
            prometheusConfig = {
              global = {
                scrape_interval = "1m";
                scrape_timeout = "30s";
              };
              scrape_configs =
                lib.optional exporterCfg.node.enable {
                  job_name = "node";
                  static_configs = [
                    {
                      targets = [ "127.0.0.1:${toString exporterCfg.node.port}" ];
                    }
                  ];
                  relabel_configs = [
                    {
                      source_labels = [ "__address__" ];
                      target_label = "instance";
                      regex = "([^:]+)(:[0-9]+)?";
                      replacement = config.networking.hostName;
                    }
                  ];
                }
                ++ lib.optional exporterCfg.collectd.enable {
                  job_name = "collectd";
                  static_configs = [
                    {
                      targets = [ "127.0.0.1:${toString exporterCfg.collectd.port}" ];
                    }
                  ];
                }
                ++ lib.optional exporterCfg.systemd.enable {
                  job_name = "systemd";
                  static_configs = [
                    {
                      targets = [ "127.0.0.1:${toString exporterCfg.systemd.port}" ];
                    }
                  ];
                };
            };
          };
        };
    };
}
