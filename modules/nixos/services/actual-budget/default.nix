{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.services.actual = {
    enable = lib.mkEnableOption "Enable actual-budget service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the actual-budget service";
    };
  };

  config =
    let
      cfg = config.${namespace}.services.actual;
    in
    lib.mkIf cfg.enable {
      services.actual = {
        enable = true;
        settings = {
          port = 5006;
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

      ${namespace}.services.backups.config.actual-budget.paths = [
        config.services.actual.settings.dataDir
      ];
    };
}
