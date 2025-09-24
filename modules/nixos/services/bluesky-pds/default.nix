{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.bluesky-pds = {
    enable = lib.mkEnableOption "Enable Bluesky PDS";
    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain to use for the Bluesky PDS";
    };
    environmentFile = lib.mkOption {
      description = "Environment variables file for the PDS server";
    };
  };

  config =
    let
      cfg = config.snowflake.services.bluesky-pds;
    in
    lib.mkIf cfg.enable {
      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ config.services.bluesky-pds.settings.PDS_PORT ];
      };
      age.secrets = {
        bluesky-pds = {
          inherit (cfg.environmentFile) file;
          owner = "pds";
          inherit (config.users.users.pds) group;
          mode = "0440";
        };
      };
      services.bluesky-pds = {
        enable = true;

        environmentFiles = [
          config.age.secrets.bluesky-pds.path
        ];

        settings = {
          PDS_HOSTNAME = cfg.domain;
        };
      };
      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = cfg.domain;
            forceSSL = true;

            locations."~ ^(/xrpc|/.well-known/atproto-did)" = {
              proxyPass = "http://localhost:${toString config.services.bluesky-pds.settings.PDS_PORT}";
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };
          };
        };
      };

      snowflake.nginx.wildcard-ssl = {
        enable = true;
        domains."${cfg.domain}".enable = true;
      };
    };
}
