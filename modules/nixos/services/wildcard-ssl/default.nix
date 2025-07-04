{
  config,
  lib,
  ...
}:
let
  cfg = config.snowflake.nginx.wildcard-ssl;
  wildcardAlias = domain: "~^(?<sub>.+)\\.${lib.strings.escape [ "." ] domain}$";
in
{
  options = with lib; {
    snowflake.nginx.wildcard-ssl = {
      enable = mkEnableOption "Enable wildcard certificate generation for nginx";
      domains = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              enable = mkEnableOption "Enable wildcard access for the given domain";
            };
          }
        );
        default = { };
        example = literalExpression ''
          {
            snowflake.nginx.wildcard-ssl.domains."example.com".enable = true;
          }
        '';
      };
      sslEnvironmentFile = lib.mkOption {
        description = "Cloudflare Environment variables file for Wildcard SSL";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    age.secrets = {
      nginx-wildcard-ssl = {
        inherit (config.snowflake.nginx.wildcard-ssl.sslEnvironmentFile) file;
        owner = "pds";
        inherit (config.users.users.pds) group;
        mode = "0440";
      };
    };

    services.nginx.virtualHosts =
      with lib;
      mapAttrs (
        domainName: domainConfig:
        mkIf domainConfig.enable {
          serverAliases = [ (wildcardAlias domainName) ];
          useACMEHost = domainName;
        }
      ) cfg.domains;

    security.acme.certs =
      with lib;
      mapAttrs (
        domainName: domainConfig:
        mkIf domainConfig.enable {
          domain = "*.${domainName}";
          extraDomainNames = [ domainName ];

          dnsProvider = "cloudflare";
          credentialsFile = config.age.secrets.nginx-wildcard-ssl.path;

          inherit (config.services.nginx) group;
        }
      ) cfg.domains;
  };
}
