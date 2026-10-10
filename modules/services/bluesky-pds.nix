{ nixos, ... }:
{
  flake.modules.nixos.bluesky-pds =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ nixos.nginx ];

      config =
        let
          cfg = config.profile.services.bluesky-pds;
        in
        {
          age.secrets = {
            bluesky-pds = {
              file = config.profile.secrets.services.bluesky-pds.environment.file;
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
                # Served with a wildcard certificate, as PDS handles live on subdomains.
                serverAliases = [ "~^(?<sub>.+)\\.${lib.strings.escape [ "." ] cfg.domain}$" ];
                useACMEHost = cfg.domain;

                locations."~ ^(/xrpc|/.well-known/atproto-did)" = {
                  proxyPass = "http://localhost:${toString config.services.bluesky-pds.settings.PDS_PORT}";
                  proxyWebsockets = true;
                  recommendedProxySettings = true;
                };
              };
            };
          };

          age.secrets.cloudflare-acme-email.file = config.profile.secrets.services.bluesky-pds.ssl-email.file;
          age.secrets.cloudflare-acme-api-key.file =
            config.profile.secrets.services.bluesky-pds.ssl-api-key.file;

          security.acme.certs.${cfg.domain} = {
            domain = "*.${cfg.domain}";
            extraDomainNames = [ cfg.domain ];
            dnsProvider = "cloudflare";
            credentialFiles = {
              "CF_API_EMAIL_FILE" = config.age.secrets.cloudflare-acme-email.path;
              "CF_API_KEY_FILE" = config.age.secrets.cloudflare-acme-api-key.path;
            };
            inherit (config.services.nginx) group;
          };
        };
    };
}
