{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.services.postgresql = {
    enable = lib.mkEnableOption "Enable postgresql service";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.postgresql_16;
      description = "Package to use for the PostgreSQL service";
    };

    enablePerformanceTuning = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable performance tuning for PostgreSQL";
    };

    backup.enable = lib.mkEnableOption "Enable backup service for postgresql databases";
  };

  config =
    let
      cfg = config.snowflake.services.postgresql;
    in
    lib.mkIf cfg.enable {
      snowflake.meta.ports.list = [ 5432 ];

      services.postgresql = {
        enable = true;
        inherit (cfg) package;

        settings = lib.mkIf cfg.enablePerformanceTuning {
          shared_buffers = "256MB";
          effective_cache_size = "1GB";
          maintenance_work_mem = "64MB";
          checkpoint_completion_target = 0.9;
          wal_buffers = "16MB";
          default_statistics_target = 100;
          random_page_cost = 1.1;
          effective_io_concurrency = 200;
          work_mem = "4MB";
          huge_pages = "try";
          min_wal_size = "1GB";
          max_wal_size = "4GB";
          max_worker_processes = 4;
          max_parallel_workers_per_gather = 2;
          max_parallel_workers = 4;
          max_parallel_maintenance_workers = 2;
        };
      };

      snowflake.services.backups.config.postgresql =
        let
          compressSuffix = ".zstd";
          compressCmd = "${pkgs.zstd}/bin/zstd -c";

          baseDir = "/var/lib/postgresql/backup";

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
