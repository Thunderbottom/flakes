{ nixos, ... }:
{
  # Services add their paths to `backups.<name>`.
  flake.modules.nixos.backup-registry =
    { lib, ... }:
    {
      options.backups = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule (
            { lib, ... }:
            {
              options = {
                dynamicFilesFrom = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  example = "find /home/user/repository -type d -name .git";
                };

                paths = lib.mkOption {
                  type = lib.types.nullOr (lib.types.listOf lib.types.str);
                  default = null;
                  example = [
                    "/etc/nixos"
                    "/var/lib/postgresql"
                  ];
                };

                user = lib.mkOption {
                  type = lib.types.str;
                  default = "root";
                  example = "postgresql";
                };

                timerConfig = lib.mkOption {
                  default = {
                    OnCalendar = "daily";
                  };
                  example = {
                    OnCalendar = "00:05";
                    RandomizedDelaySec = "5h";
                  };
                };
              };
            }
          )
        );
      };
    };

  # Runs restic for everything registered. Only for hosts that can decrypt the restic secrets.
  flake.modules.nixos.backups =
    { config, lib, ... }:
    let
      cfg = config.backups;
    in
    {
      imports = [ nixos.backup-registry ];

      age.secrets = {
        restic-environment.file = config.profile.secrets.services.backups.environment.file;
        restic-password.file = config.profile.secrets.services.backups.password.file;
      };

      services.restic.backups = lib.mapAttrs' (
        name: value:
        lib.nameValuePair name (
          {
            initialize = true;

            repository = "${config.profile.backupRepository}:/${config.system.name}/${name}";
            environmentFile = config.age.secrets.restic-environment.path;
            passwordFile = config.age.secrets.restic-password.path;

            pruneOpts = [
              "--keep-daily 7"
              "--keep-weekly 5"
              "--keep-monthly 12"
            ];
          }
          // value
        )
      ) cfg;
    };
}
