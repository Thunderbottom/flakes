{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.monitoring.victoriametrics =
    let
      settingsFormat = pkgs.formats.json { };
    in
    {
      enable = lib.mkEnableOption "Enable victoriametrics and vmagent stack";

      port = lib.mkOption {
        type = lib.types.port;
        default = 8428;
        description = "Port to listen on for victoriametrics";
      };

      extraPrometheusConfig = lib.mkOption {
        description = "Extra prometheus scrape config for vmagent";
        type = lib.types.listOf (lib.types.submodule { freeformType = settingsFormat.type; });
        default = [ ];
      };
    };

  config =
    let
      cfg = config.snowflake.monitoring.victoriametrics;
      exporterCfg = config.services.prometheus.exporters;
    in
    lib.mkIf cfg.enable {
      services.victoriametrics = {
        inherit (cfg) enable;
        listenAddress = "127.0.0.1:${toString cfg.port}";
        retentionPeriod = "90d";
      };
      services.vmagent = {
        inherit (cfg) enable;
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
            }
            ++ cfg.extraPrometheusConfig;
        };
      };
    };
}
