{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.services.immich = {
    enable = lib.mkEnableOption "Enable immich service";

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
      };

      users.users.immich.extraGroups = ["media" "video" "render"];

      # Requires services.nginx.enable.
      services.nginx = {
        virtualHosts = {
          "${cfg.domain}" = {
            serverName = "${cfg.domain}";
            enableACME = true;
            forceSSL = true;
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
    };
}
