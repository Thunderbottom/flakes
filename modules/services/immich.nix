{ nixos, ... }:
{
  flake.modules.nixos.immich =
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
      ];

      config =
        let
          cfg = config.profile.services.immich;
        in
        {

          services.immich = {
            enable = true;
            package = pkgs.immich;
            inherit (cfg) port;
            mediaLocation = "/storage/media/immich-library";

            environment = {
            };
          };

          users.users.immich.extraGroups = [
            "media"
            "video"
            "render"
          ];

          proxy.immich = {
            inherit (cfg) domain;
            upstream = "http://${config.services.immich.host}:${toString config.services.immich.port}/";
            websockets = true;
            extraLocations."/metrics".extraConfig = ''
              deny all;
            '';
            extraConfig = ''
              client_max_body_size 0;
              proxy_connect_timeout 600;
              proxy_read_timeout 600;
              proxy_send_timeout 600;
            '';
          };

          fail2ban.immich = {
            failregex = "^.*Failed login attempt for user .* from ip address <ADDR>$";
            unit = "immich-server.service";
          };
        };
    };
}
