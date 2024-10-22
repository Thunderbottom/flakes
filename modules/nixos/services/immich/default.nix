{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.services.immich = {
    enable = lib.mkEnableOption "Enable immich service";
    monitoring.enable = lib.mkEnable "Enable immich monitoring";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the immich service";
    };
  };

  config = let
    cfg = config.snowflake.services.immich;
  in
    lib.mkIf cfg.enable {
      services.immich = {
        enable = true;
        package = pkgs.immich;
        mediaLocation = "/storage/media/immich-library";
        port = 9121;

        environment = {
          IMMICH_METRICS =
            if cfg.monitoring.enable
            then "true"
            else "false";
        };
      };

      users.users.immich.extraGroups = ["media" "video" "render"];

      # Requires services.nginx.enable.
      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
            locations."/metrics" = {
              extraConfig = ''
                deny all;
              '';
            };

            locations."/" = {
              proxyPass = "http://${config.services.immich.host}:${toString config.services.immich.port}/";
              proxyWebsockets = true;
            };
            extraConfig = ''
              client_max_body_size 0;
              proxy_connect_timeout 600;
              proxy_read_timeout 600;
              proxy_send_timeout 600;

              add_header Content-Security-Policy "default-src 'self'; script-src 'self' https://${cfg.domain} https://static.immich.cloud https://tiles.immich.cloud 'sha256-h5wSYKWbmHcoYTdkHNNguMswVNCphpvwW+uxooXhF/Y=' 'sha256-lKeXpeCMSkZLF5wgriN98a1ykRBCe5ThK7QWajyrvE8='; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self' https://${cfg.domain} https://tiles.immich.cloud https://static.immich.cloud; frame-ancestors 'self'; worker-src 'self' blob:;" always;

              add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
              add_header Referrer-Policy "no-referrer-when-downgrade" always;
              add_header Cross-Origin-Embedder-Policy "require-corp" always;
              add_header Cross-Origin-Opener-Policy "same-origin" always;
              add_header Cross-Origin-Resource-Policy "same-origin" always;
              add_header X-Frame-Options "SAMEORIGIN" always;
              add_header X-Content-Type-Options "nosniff" always;
            '';
          };
        };
      };

      services.fail2ban.jails.immich = {
        enabled = true;
        filter = "immich";
      };

      environment.etc = {
        immich = {
          target = "fail2ban/filter.d/immich.conf";
          text = ''
            [INCLUDES]
            before = common.conf

            [Definition]
            failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
            ignoreregex =
            journalmatch = _SYSTEMD_UNIT=immich-server.service
          '';
        };
      };
    };
}
