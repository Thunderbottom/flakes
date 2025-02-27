{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.services.postgresql = {
    enable = lib.mkEnableOption "Enable postgresql service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.postgresql_16;
      description = "Package to use for the PostgreSQL service";
    };

    backup.enable = lib.mkEnableOption "Enable backup service for postgresql databases";
  };

  config = let
    cfg = config.${namespace}.services.postgresql;
  in
    lib.mkIf cfg.enable {
      services.postgresql = {
        enable = true;
        package = cfg.package;
      };

      ${namespace}.services.backups.config.postgresql = let
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
    };
}
