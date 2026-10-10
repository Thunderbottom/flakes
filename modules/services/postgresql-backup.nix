{ nixos, ... }:
{
  flake.modules.nixos.postgresql-backup =
    { config, pkgs, ... }:
    {
      imports = [
        nixos.postgresql
        nixos.backup-registry
      ];

      config = {
        backups.postgresql =
          let
            compressSuffix = ".zstd";
            compressCmd = "${pkgs.zstd}/bin/zstd -c";

            baseDir = "/var/lib/postgresql/backup";

            mkSqlPath = prefix: suffix: "/${baseDir}/all${prefix}.sql${suffix}";
            curFile = mkSqlPath "" compressSuffix;
            prevFile = mkSqlPath ".prev" compressSuffix;
            inProgressFile = mkSqlPath ".in-progress" compressSuffix;
          in
          {
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
    };
}
