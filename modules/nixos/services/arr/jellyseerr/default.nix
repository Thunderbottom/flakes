{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.seerr = {
    enable = lib.mkEnableOption "Enable seerr deployment configuration";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Configuration domain to use for the seerr service";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "Configuration port to use for the seerr service";
    };
  };

  config =
    let
      cfg = config.snowflake.services.seerr;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domain != "";
          message = "snowflake.services.seerr.domain must be set when enabled";
        }
      ];

      snowflake.meta = {
        domains.list = [ cfg.domain ];
        ports.list = [ cfg.port ];
      };
      services.seerr.enable = true;
      services.seerr.openFirewall = true;

      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = cfg.domain;
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://localhost:${toString cfg.port}/";
            };
          };
        };
      };

      snowflake.services.backups.config.seerr.paths = [
        config.services.seerr.configDir
      ];

      environment.etc = {
        seerr = {
          target = "fail2ban/filter.d/seerr.conf";
          text = ''
            [INCLUDES]
            before = common.conf

            [Definition]
            failregex = ^.*\[warn\]\[API\]: Failed sign-in attempt using invalid Overseerr password {"ip":"<HOST>","email":
                        ^.*\[warn\]\[Auth\]: Failed login attempt from user with incorrect Jellyfin credentials {"account":{"ip":"<HOST>","email":
            ignoreregex =
            journalmatch = _SYSTEMD_UNIT=seerr.service
          '';
        };
      };
    };
}
