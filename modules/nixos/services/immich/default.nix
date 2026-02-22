{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.services.immich = {
    enable = lib.mkEnableOption "Enable immich service";
    monitoring.enable = lib.mkEnableOption "Enable immich monitoring";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the immich service";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9121;
      description = "Configuration port to use for the immich service";
    };

    mediaLocation = lib.mkOption {
      type = lib.types.path;
      default = "/storage/media/immich-library";
      description = "Path to the immich media library";
    };
  };

  config =
    let
      cfg = config.snowflake.services.immich;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "snowflake.services.immich.domain must be set when enabled";
        }
      ];

      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ cfg.port ];
      };

      services.immich = {
        enable = true;
        package = pkgs.immich;
        inherit (cfg) port mediaLocation;

        environment = {
          IMMICH_TELEMETRY_INCLUDE = if cfg.monitoring.enable then "all" else "";
        };
      };

      users.users.immich.extraGroups = [
        "media"
        "video"
        "render"
      ];

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
