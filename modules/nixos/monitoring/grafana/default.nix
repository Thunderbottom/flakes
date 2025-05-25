{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.monitoring.grafana =
    let
      settingsFormat = pkgs.formats.yaml { };
    in
    {
      enable = lib.mkEnableOption "Enable grafana for monitoring stack";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Configuration domain to use for the grafana service";
      };

      adminPasswordFile = lib.mkOption {
        description = "Age module containing the administrator password to use for grafana";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3010;
        description = "Configuration port to use for the grafana service";
      };

      extraDatasourceConfig = lib.mkOption {
        description = "Extra datasource configuration for grafana";
        type = lib.types.listOf (lib.types.submodule { freeformType = settingsFormat.type; });
        default = [ ];
      };
    };

  config =
    let
      cfg = config.${namespace}.monitoring.grafana;
    in
    lib.mkIf cfg.enable {
      age.secrets.grafana = {
        inherit (cfg.adminPasswordFile) file;
        owner = "grafana";
        group = "grafana";
      };

      services.grafana = {
        enable = true;

        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = cfg.port;
          };

          analytics = {
            reporting_enabled = false;
            feedback_links_enabled = false;
          };
          security.admin_password = "$__file{${config.age.secrets.grafana.path}}";
        };

        provision = {
          enable = true;

          datasources.settings.datasources =
            lib.optional config.services.victoriametrics.enable {
              name = "Victoriametrics";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.${namespace}.monitoring.victoriametrics.port}";
            }
            ++ cfg.extraDatasourceConfig;
        };
      };

      # Requires services.nginx.enable.
      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}/";
            };
          };
        };
      };
    };
}
