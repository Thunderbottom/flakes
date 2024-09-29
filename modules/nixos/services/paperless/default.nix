{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.services.paperless = {
    enable = lib.mkEnableOption "Enable paperless service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the paperless service";
    };

    passwordFile = lib.mkOption {
      description = "Age module containing the password to use for paperless";
    };

    adminUser = lib.mkOption {
      type = lib.types.str;
      description = "Administrator username for the paperless service";
    };
  };

  config = let
    cfg = config.snowflake.services.paperless;
  in
    lib.mkIf cfg.enable {
      age.secrets.paperless = {
        inherit (cfg.passwordFile) file;
        owner = "paperless";
        group = "paperless";
      };

      services.paperless = {
        enable = true;
        package = pkgs.paperless-ngx;

        passwordFile = config.age.secrets.paperless.path;

        settings = {
          PAPERLESS_URL = "https://${cfg.domain}";
          PAPERLESS_OCR_LANGUAGE = "eng";
          PAPERLESS_TASK_WORKERS = 4;
          PAPERLESS_THREADS_PER_WORKER = 4;
          PAPERLESS_ADMIN_USER = cfg.adminUser;
          PAPERLESS_FILENAME_FORMAT = "{created_year}/{document_type}/{title}";
        };
      };

      # Requires services.nginx.enable.
      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}/";
              proxyWebsockets = true;
            };
          };
        };
      };

      snowflake.services.backups.paperless.config = {
        dynamicFilesFrom = let
          path = config.services.paperless.dataDir;
        in ''
          mkdir -p ${path}/exported
          ${path}/paperless-manage document_exporter ${path}/exported
          echo ${path}/exported/
        '';
      };
    };
}
