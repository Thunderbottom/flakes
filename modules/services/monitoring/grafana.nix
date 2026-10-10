{ nixos, ... }:
{
  flake.modules.nixos.grafana =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ nixos.proxy ];

      config =
        let
          cfg = config.profile.services.grafana;
        in
        {
          age.secrets.grafana = {
            file = config.profile.secrets.monitoring.grafana.password.file;
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
              security = {
                admin_password = "$__file{${config.age.secrets.grafana.path}}";
                secret_key = "$__file{${config.age.secrets.grafana.path}}";
              };
            };

            provision = {
              enable = true;

              datasources.settings.datasources = lib.optional config.services.victoriametrics.enable {
                name = "Victoriametrics";
                type = "prometheus";
                access = "proxy";
                url = "http://127.0.0.1:${toString config.profile.services.victoriametrics.port}";
              };
            };
          };

          proxy.grafana = {
            inherit (cfg) domain;
            upstream = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}/";
          };
        };
    };
}
