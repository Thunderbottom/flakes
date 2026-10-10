{ nixos, ... }:
{
  flake.modules.nixos.vaultwarden =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        nixos.proxy
        nixos.postgresql
        nixos.fail2ban
        nixos.backup-registry
      ];

      config =
        let
          cfg = config.profile.services.vaultwarden;
        in
        {

          age.secrets.vaultwarden = {
            file = config.profile.secrets.services.vaultwarden.password.file;
            owner = "vaultwarden";
            group = "vaultwarden";
          };

          services.vaultwarden = {
            enable = true;
            package = pkgs.vaultwarden;

            environmentFile = config.age.secrets.vaultwarden.path;

            dbBackend = "postgresql";

            config = {
              domain = "https://${cfg.domain}";
              signupsAllowed = false;

              rocketAddress = "127.0.0.1";
              rocketPort = cfg.port;

              databaseUrl = "postgres:///vaultwarden?host=/var/run/postgresql";
            };
          };

          services.postgresql = {
            ensureDatabases = [ "vaultwarden" ];
            ensureUsers = [
              {
                name = "vaultwarden";
                ensureDBOwnership = true;
              }
            ];
          };

          proxy.vaultwarden = {
            inherit (cfg) domain;
            upstream = "http://${config.services.vaultwarden.config.rocketAddress}:${toString config.services.vaultwarden.config.rocketPort}/";
          };

          backups.vaultwarden.paths = [
            "/var/lib/vaultwarden"
          ];

          fail2ban.vaultwarden = {
            failregex = ''^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$'';
          };
        };
    };
}
