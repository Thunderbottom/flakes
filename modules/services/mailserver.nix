{ nixos, ... }:
{
  flake.modules.nixos.mailserver =
    {
      config,
      inputs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.nixos-mailserver.nixosModules.mailserver
        nixos.nginx
        nixos.fail2ban
      ];

      config =
        let
          cfg = config.mailserver;
        in
        {
          mailserver = {
            enable = true;
            stateVersion = 3;

            # Spin up a stripped-down nginx instance on
            # port 80 to generate a certificate automatically.
            x509.useACMEHost = cfg.fqdn;

            storage.directoryLayout = "fs";
          };

          security.acme.certs.${cfg.fqdn} = {
            reloadServices = [
              "postfix.service"
              "dovecot.service"
            ];
            webroot = "/var/lib/acme/acme-challenge";
          };

          services.nginx.virtualHosts."${cfg.fqdn}" = {
            locations."/.well-known/acme-challenge" = {
              root = "/var/lib/acme/acme-challenge";
            };
          };

          # Prefer using ipv4 and use correct ipv6
          # address to avoid rDNS issues
          services.postfix.settings.main = {
            smtp_address_preference = "ipv4";
          };

          services.fail2ban.jails = {
            postfix = {
              settings = {
                enabled = true;
                mode = "extra";
              };
            };

            dovecot = {
              settings = {
                enabled = true;
                filter = "dovecot[mode=aggressive]";
                maxretry = 3;
              };
            };
          };
        };
    };
}
