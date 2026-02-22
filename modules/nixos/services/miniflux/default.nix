{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.miniflux = {
    enable = lib.mkEnableOption "Enable miniflux service";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the miniflux service";
    };

    adminTokenFile = lib.mkOption {
      description = "Age module containing the ADMIN_USERNAME and ADMIN_PASSWORD to use for miniflux";
    };

    port = lib.mkOption {
      type = lib.types.int;
      description = "Configuration port for the miniflux service to listen on";
      default = 8816;
    };
  };

  config =
    let
      cfg = config.snowflake.services.miniflux;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "snowflake.services.miniflux.domain must be set when enabled";
        }
      ];

      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ cfg.port ];
      };

      age.secrets.miniflux = {
        inherit (cfg.adminTokenFile) file;
        owner = "miniflux";
        group = "miniflux";
      };

      services.miniflux.enable = true;
      services.miniflux.adminCredentialsFile = config.age.secrets.miniflux.path;

      services.miniflux.config = {
        LISTEN_ADDR = "localhost:${toString cfg.port}";
        BASE_URL = "https://${cfg.domain}";
      };

      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://localhost:${toString cfg.port}";
              extraConfig = ''
                proxy_redirect off;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
      };

      services.fail2ban.jails.miniflux = {
        enabled = true;
        filter = "miniflux";
      };

      environment.etc = {
        miniflux = {
          target = "fail2ban/filter.d/miniflux.conf";
          text = ''
            [Definition]
            failregex = ^.*msg="[^"]*(Incorrect|Invalid) username or password[^"]*".*client_ip=<ADDR>
            ignoreregex =
            journalmatch = _SYSTEMD_UNIT=miniflux.service
          '';
        };
      };
    };
}
