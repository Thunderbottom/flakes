{
  flake.modules.nixos.postgresql =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config =
        let
          cfg = {
            package = pkgs.postgresql_16;
          };
        in
        {

          services.postgresql = {
            enable = true;
            inherit (cfg) package;

            settings = {
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
        };
    };
}
