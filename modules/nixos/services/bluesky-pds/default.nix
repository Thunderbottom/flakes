{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.services.bluesky-pds = {
    enable = lib.mkEnableOption "Enable Bluesky PDS";
    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain to use for the Bluesky PDS";
    };
    environmentFile = lib.mkOption {
      description = "Environment variables file for the PDS server";
    };
  };

  config = lib.mkIf config.${namespace}.services.bluesky-pds.enable {
    age.secrets = {
      bluesky-pds = {
        inherit (config.${namespace}.services.bluesky-pds.environmentFile) file;
        owner = "pds";
        group = config.users.users.pds.group;
        mode = "0440";
      };
    };
    services.pds = {
      enable = true;

      environmentFiles = [
        config.age.secrets.bluesky-pds.path
      ];

      settings = {
        PDS_HOSTNAME = config.${namespace}.services.bluesky-pds.domain;
      };
    };
    services.nginx = {
      virtualHosts = {
        "${config.${namespace}.services.bluesky-pds.domain}" = {
          serverName = config.${namespace}.services.bluesky-pds.domain;
          forceSSL = true;

          locations."~ ^(/xrpc|/.well-known/atproto-did)" = {
            proxyPass = "http://localhost:${toString config.services.pds.settings.PDS_PORT}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        };
      };
    };

    ${namespace}.nginx.wildcard-ssl.domains."${config.${namespace}.services.bluesky-pds.domain
    }".enable =
      true;
  };
}
