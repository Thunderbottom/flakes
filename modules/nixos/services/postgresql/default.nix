{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.services.postgresql = {
    enable = lib.mkEnableOption "Enable postgresql service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.postgresql_14;
      description = "Package to use as a root directory for the static site";
    };

    backup.enable = lib.mkEnableOption "Enable backup service for postgresql databases";
    upgrade.enable = lib.mkEnableOption "Enable upgrade-pg-cluster script for postgresql";
  };

  config = let
    cfg = config.snowflake.services.postgresql;
  in
    lib.mkIf cfg.enable {
      services.postgresql = {
        enable = true;
        package = cfg.package;
      };

      snowflake.services.backup.config.postgresql = let
        compressSuffix = ".zstd";
        compressCmd = "${pkgs.zstd}/bin/zstd -c";

        baseDir = "/tmp/postgres-backup";

        mkSqlPath = prefix: suffix: "/${baseDir}/all${prefix}.sql${suffix}";
        curFile = mkSqlPath "" compressSuffix;
        prevFile = mkSqlPath ".prev" compressSuffix;
        inProgressFile = mkSqlPath ".in-progress" compressSuffix;
      in
        lib.mkIf cfg.backup.enable {
          dynamicFilesFrom = ''
            set -e -o pipefail

            mkdir -p ${baseDir}

            # Ensure that the backup folder is only readable by the postgres user
            umask 0077

            if [ -e ${curFile} ]; then
              rm -f ${prevFile}
              mv ${curFile} ${prevFile}
            fi

            ${config.security.sudo.package}/bin/sudo -u postgres ${config.services.postgresql.package}/bin/pg_dumpall \
              | ${compressCmd} \
              > ${inProgressFile}

            mv ${inProgressFile} ${curFile}

            echo ${curFile}
          '';
        };

      # NOTE: login with `sudo su -` and run `upgrade-pg-cluster` to perform
      # the upgrade. Ensure that you run `VACUUMDB` commands after the upgrade,
      # and then update the postgres package version in the service config.
      environment.systemPackages = lib.mkIf cfg.upgrade.enable [
        (let
          newPostgres = pkgs.postgresql_16.withPackages (ps: [
            # Immich requires pgvecto-rs
            ps.pgvecto-rs
          ]);
        in
          pkgs.writeScriptBin "upgrade-pg-cluster" ''
            set -eux
            # It's perhaps advisable to stop all services that depend on postgresql
            systemctl stop postgresql

            export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"

            export NEWBIN="${newPostgres}/bin"

            export OLDDATA="${config.services.postgresql.dataDir}"
            export OLDBIN="${config.services.postgresql.package}/bin"

            install -d -m 0700 -o postgres -g postgres "$NEWDATA"
            cd "$NEWDATA"
            sudo -u postgres $NEWBIN/initdb -D "$NEWDATA"

            sudo -u postgres $NEWBIN/pg_upgrade \
              --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
              --old-bindir $OLDBIN --new-bindir $NEWBIN \
              "$@"
          '')
      ];
    };
}
