{
  config,
  pkgs,
  ...
}: let
  domain = "bw.deku.moe";
in {
  age.secrets.vaultwarden = {
    file = ../../../secrets/vaultwarden.age;
    owner = "vaultwarden";
    group = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    package = pkgs.vaultwarden;

    environmentFile = config.age.secrets.vaultwarden.path;
    dbBackend = "postgresql";

    config = {
      domain = "https://${domain}";
      signupsAllowed = false;

      rocketAddress = "127.0.0.1";
      rocketPort = 33003;

      databaseUrl = "postgres:///vaultwarden?host=/var/run/postgresql";
    };
  };

  services.postgresql.ensureDatabases = ["vaultwarden"];
  services.postgresql.ensureUsers = [
    {
      name = "vaultwarden";
      ensureDBOwnership = true;
    }
  ];

  services.nginx = {
    virtualHosts = {
      "${domain}" = {
        serverName = "${domain}";
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.rocketPort}/";
        };
      };
    };
  };
}
