{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.navidrome = {
    enable = lib.mkEnableOption "Enable navidrome deployment configuration";

    port = lib.mkOption {
      type = lib.types.port;
      default = 4533;
      description = "The port to run navidrome on";
    };

    musicFolder = lib.mkOption {
      type = lib.types.str;
      description = "The music folder path to use for navidrome";
    };
  };

  config =
    let
      cfg = config.snowflake.services.navidrome;
    in
    lib.mkIf cfg.enable {
      services.navidrome = {
        enable = true;
        group = "media";
        settings = {
          Address = "127.0.0.1";
          Port = cfg.port;
          MusicFolder = cfg.musicFolder;
        };
      };

      services.nginx = {
        virtualHosts = {
          "music.deku.moe" = {
            serverName = "music.deku.moe";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyWebsockets = true;
              proxyPass = "http://localhost:${toString cfg.port}/";
              extraConfig = ''
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
              '';
            };
          };
        };
      };

      services.fail2ban.jails.navidrome = {
        enabled = true;
        filter = "navidrome";
      };

      environment.etc = {
        navidrome = {
          target = "fail2ban/filter.d/navidrome.conf";
          text = ''
            [INCLUDES]
            before = common.conf

            [Definition]
            failregex = msg="Unsuccessful login".*X-Real-Ip:\[<HOST>\]
            ignoreregex =
            journalmatch = _SYSTEMD_UNIT=navidrome.service
          '';
        };
      };
    };
}
