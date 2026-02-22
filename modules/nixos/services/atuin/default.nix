{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.atuin = {
    enable = lib.mkEnableOption "Enable atuin-server service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the atuin-server service";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Configuration port to use for the atuin-server service";
    };
  };

  config =
    let
      cfg = config.snowflake.services.atuin;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "snowflake.services.atuin.domain must be set when enabled";
        }
      ];

      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ cfg.port ];
      };

      services.atuin = {
        enable = true;
        inherit (cfg) port;
        openFirewall = false;
        openRegistration = false;
        database.createLocally = true;
      };

      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://${config.services.atuin.host}:${toString config.services.atuin.port}/";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
}
