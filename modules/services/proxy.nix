{ nixos, ... }:
{
  # Services declare `proxy.<name>`, and each becomes a TLS vhost in nginx.
  flake.modules.nixos.proxy =
    { config, lib, ... }:
    {
      imports = [ nixos.nginx ];

      options.proxy = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              domain = lib.mkOption {
                type = lib.types.str;
              };
              upstream = lib.mkOption {
                type = lib.types.str;
              };
              websockets = lib.mkEnableOption "websocket proxying";
              locationConfig = lib.mkOption {
                type = lib.types.lines;
                default = "";
              };
              extraLocations = lib.mkOption {
                type = lib.types.attrs;
                default = { };
              };
              extraConfig = lib.mkOption {
                type = lib.types.lines;
                default = "";
              };
            };
          }
        );
      };

      config.services.nginx.virtualHosts = lib.mapAttrs' (
        _: proxy:
        lib.nameValuePair proxy.domain {
          serverName = proxy.domain;
          enableACME = true;
          forceSSL = true;
          inherit (proxy) extraConfig;
          locations = {
            "/" = {
              proxyPass = proxy.upstream;
              proxyWebsockets = proxy.websockets;
              extraConfig = proxy.locationConfig;
            };
          }
          // proxy.extraLocations;
        }
      ) config.proxy;
    };
}
