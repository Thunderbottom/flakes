{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.services.jellyseerr = {
    enable = lib.mkEnableOption "Enable jellyseerr deployment configuration";
  };

  config = lib.mkIf config.${namespace}.services.jellyseerr.enable {
    services.jellyseerr.enable = true;
    services.jellyseerr.openFirewall = true;
    services.nginx = {
      virtualHosts = {
        "seerr.deku.moe" = {
          serverName = "seerr.deku.moe";
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://localhost:5055/";
          };
        };
      };
    };
    environment.etc = {
      jellyseerr = {
        target = "fail2ban/filter.d/jellyseerr.conf";
        text = ''
          [INCLUDES]
          before = common.conf

          [Definition]
          failregex = ^.*\[warn\]\[API\]: Failed sign-in attempt using invalid Overseerr password {"ip":"<HOST>","email":
                      ^.*\[warn\]\[Auth\]: Failed login attempt from user with incorrect Jellyfin credentials {"account":{"ip":"<HOST>","email":
          ignoreregex =
          journalmatch = _SYSTEMD_UNIT=jellyseerr.service
        '';
      };
    };
  };
}
