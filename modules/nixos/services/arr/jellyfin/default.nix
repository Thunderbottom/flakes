{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.jellyfin = {
    enable = lib.mkEnableOption "Enable jellyfin deployment configuration";
  };

  config =
    let
      cfg = config.snowflake.services.jellyfin;
    in
    lib.mkIf cfg.enable {
      services.jellyfin = {
        enable = true;
        openFirewall = true;
      };

      users.groups.media = {
        members = [
          "@wheel"
          "jellyfin"
        ];
      };

      nixpkgs.config.packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
      };

      services.jellyseerr.enable = true;
      services.jellyseerr.openFirewall = true;

      services.nginx = {
        virtualHosts = {
          "jelly.deku.moe" = {
            serverName = "jelly.deku.moe";
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyWebsockets = true;
              proxyPass = "http://localhost:8096/";
              extraConfig = ''
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_hide_header X-Frame-Options;
              '';
            };
          };
        };
      };

      services.fail2ban.jails.jellyfin = {
        enabled = true;
        filter = "jellyfin";
      };

      environment.etc = {
        jellyfin = {
          target = "fail2ban/filter.d/jellyfin.conf";
          text = ''
            [INCLUDES]
            before = common.conf

            [Definition]
            failregex = ^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.
            ignoreregex =
            journalmatch = _SYSTEMD_UNIT=jellyfin.service
          '';
        };
      };
    };
}
