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
      credentialFiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        description = "Credential files for the DNS provider (passed as systemd credentials). Keys are environment variable names suffixed with _FILE.";
        default = { };
        example = lib.literalExpression ''
          { "CF_DNS_API_TOKEN_FILE" = config.age.secrets.cloudflare-api-token.path; }
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {

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
          credentialFiles = cfg.credentialFiles;

          inherit (config.services.nginx) group;
        }
      ) cfg.domains;
  };
}
