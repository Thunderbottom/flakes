{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.services.vaultwarden = {
    enable = lib.mkEnableOption "Enable vaultwarden service with postgres and nginx";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the vaultwarden service";
    };

    adminTokenFile = lib.mkOption {
      description = "Age module containing the ADMIN_TOKEN to use for vaultwarden";
    };
  };

  # TODO: when upgrading stateVersion to 24.11, the data directory will
  # change from /var/lib/bitwarden_rs to /var/lib/vaultwarden.
  # We need to move the data and then change the backup service directory.
  config = let
    cfg = config.snowflake.services.vaultwarden;
  in
    lib.mkIf cfg.enable {
      age.secrets.vaultwarden = {
        inherit (cfg.adminTokenFile) file;
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
          rocketPort = 33003;

          databaseUrl = "postgres:///vaultwarden?host=/var/run/postgresql";
        };
      };

      services.postgresql = {
        # NOTE: To upgrade postgresql to a newer version, refer:
        # https://nixos.org/manual/nixos/stable/#module-services-postgres-upgrading
        package = pkgs.postgresql_14;
        ensureDatabases = ["vaultwarden"];
        ensureUsers = [
          {
            name = "vaultwarden";
            ensureDBOwnership = true;
          }
        ];
      };

      # Requires services.nginx.enable.
      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://${config.services.vaultwarden.config.rocketAddress}:${toString config.services.vaultwarden.config.rocketPort}/";
            };
          };
        };
      };

      snowflake.services.backups.vaultwarden.paths = [
        "/var/lib/bitwarden_rs"
      ];
    };
}
