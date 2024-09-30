{
  config,
  lib,
  ...
}:
with lib; {
  options.snowflake.services.backups = {
    enable = mkEnableOption "Enable restic backup service";

    resticEnvironmentFile = mkOption {
      description = "Age module containing the restic environment details";
    };

    resticPasswordFile = mkOption {
      description = "Age module containing the restic password";
    };

    repository = mkOption {
      description = "Repository to use as the restic endpoint. Must be in the form of <provider>:<repository>";
      type = types.str;
      example = "b2:nix-backup-repository";
    };

    config = mkOption {
      default = {};
      type = types.attrsOf (
        types.submodule (
          {lib, ...}: {
            options = {
              dynamicFilesFrom = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  A script that produces a list of files to back up.
                  The result of this command are given to the `--files-from` option.
                '';
                example = "find /home/user/repository -type d -name .git";
              };

              paths = mkOption {
                type = types.nullOr (types.listOf types.str);
                default = null;
                description = ''
                  List of paths to bck up. If null or an empty array,
                  no backup command will be run. This can be used to
                  create a prune-only job.
                '';
                example = [
                  "/etc/nixos"
                  "/var/lib/postgresql"
                ];
              };

              user = mkOption {
                type = types.str;
                default = "root";
                description = ''
                  The user under which the backup should run.
                '';
                example = "postgresql";
              };

              timerConfig = mkOption {
                default = {
                  OnCalendar = "daily";
                };
                description = ''
                  When to run the backup process. See man systemd.timer for details.
                '';
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

  config = let
    cfg = config.snowflake.services.backups;
  in
    mkIf cfg.enable {
      age.secrets = {
        restic-environment.file = cfg.resticEnvironmentFile.file;
        restic-password.file = cfg.resticPasswordFile.file;
      };

      services.restic.backups =
        mapAttrs' (
          name: value:
            nameValuePair name (
              {
                initialize = true;

                repository = "${cfg.repository}:/${config.system.name}/${name}";
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
        )
        cfg.config;
    };
}
