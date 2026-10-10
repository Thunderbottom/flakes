{ nixos, ... }:
{
  flake.modules.nixos.paperless =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        nixos.proxy
        nixos.fail2ban
        nixos.backup-registry
      ];

      config =
        let
          cfg = config.profile.services.paperless;
        in
        {

          age.secrets.paperless = {
            file = config.profile.secrets.services.paperless.password.file;
            owner = "paperless";
            group = "paperless";
          };

          services.paperless = {
            enable = true;
            package = pkgs.paperless-ngx;
            inherit (cfg) port;
            passwordFile = config.age.secrets.paperless.path;

            settings = {
              PAPERLESS_URL = "https://${cfg.domain}";
              PAPERLESS_TASK_WORKERS = 4;
              PAPERLESS_THREADS_PER_WORKER = 4;
              PAPERLESS_ADMIN_USER = "chinmay";
              PAPERLESS_FILENAME_FORMAT = "{created_year}/{document_type}/{title}";
            };
          };

          proxy.paperless = {
            inherit (cfg) domain;
            upstream = "http://127.0.0.1:${toString config.services.paperless.port}/";
            websockets = true;
          };

          backups.paperless = {
            dynamicFilesFrom =
              let
                path = config.services.paperless.dataDir;
              in
              ''
                mkdir -p ${path}/exported
                ${path}/paperless-manage document_exporter ${path}/exported
                echo ${path}/exported/
              '';
          };

          fail2ban.paperless = {
            failregex = ''Login failed for user `.*` from (?:IP|private IP) `<HOST>`\.$'';
            unit = "paperless-web.service";
          };
        };
    };
}
