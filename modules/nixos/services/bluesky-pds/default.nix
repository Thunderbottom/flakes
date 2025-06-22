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

  config = lib.mkIf config.snowflake.services.bluesky-pds.enable {
    age.secrets = {
      bluesky-pds = {
        inherit (config.snowflake.services.bluesky-pds.environmentFile) file;
        owner = "pds";
        inherit (config.users.users.pds) group;
        mode = "0440";
      };
    };
    services.pds = {
      enable = true;

      environmentFiles = [
        config.age.secrets.bluesky-pds.path
      ];

      settings = {
        PDS_HOSTNAME = config.snowflake.services.bluesky-pds.domain;
      };
    };
    services.nginx = {
      virtualHosts = {
        "${config.snowflake.services.bluesky-pds.domain}" = {
          serverName = config.snowflake.services.bluesky-pds.domain;
          forceSSL = true;

          locations."~ ^(/xrpc|/.well-known/atproto-did)" = {
            proxyPass = "http://localhost:${toString config.services.pds.settings.PDS_PORT}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        };
      };
    };

    snowflake.nginx.wildcard-ssl = {
      enable = true;
      domains."${config.snowflake.services.bluesky-pds.domain}".enable = true;
    };
  };
}
