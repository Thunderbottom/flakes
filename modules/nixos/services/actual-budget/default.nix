{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.actual = {
    enable = lib.mkEnableOption "Enable actual-budget service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the actual-budget service";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5006;
      description = "Configuration port to use for the actual-budget service";
    };
  };

  config =
    let
      cfg = config.snowflake.services.actual;
    in
    lib.mkIf cfg.enable {
      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ cfg.port ];
      };

      services.actual = {
        enable = true;
        settings = {
          port = cfg.port;
        };
      };

      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.actual.settings.port}/";
              proxyWebsockets = true;
            };
          };
        };
      };

      snowflake.services.backups.config.actual-budget.paths = [
        config.services.actual.settings.dataDir
      ];
    };
}
