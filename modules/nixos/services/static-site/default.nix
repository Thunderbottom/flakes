{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.services.static-sites = {
    sites = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Enable this static site";
            package = lib.mkOption {
              type = lib.types.package;
              description = "Package to use as a root directory for the static site";
            };
            domain = lib.mkOption {
              type = lib.types.str;
              description = "Domain to use for the static site";
            };
            extraConfig = lib.mkOption {
              type = lib.types.attrs;
              default = { };
              description = "Additional nginx configuration for this virtual host";
            };
          };
        }
      );
      default = { };
      description = "Attribute set of static sites to configure";
    };
  };

  config = {
    services.nginx.virtualHosts = lib.mapAttrs (
      name: site:
      lib.mkIf site.enable {
        serverName = site.domain;
        enableACME = true;
        forceSSL = true;
        root = site.package;
      }
      // site.extraConfig
    ) (lib.filterAttrs (name: site: site.enable) config.${namespace}.services.static-sites.sites);
  };
}
