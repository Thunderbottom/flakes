{
  config,
  lib,
  ...
}:
{
  options.snowflake.services.cloudflare-dyndns = {
    enable = lib.mkEnableOption "Enable Cloudflare Dynamic DNS service";

    apiTokenFile = lib.mkOption {
      description = "Age module containing the Cloudflare API token for DDNS updates";
    };

    domains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of domains to update with dynamic DNS";
    };

    frequency = lib.mkOption {
      type = lib.types.str;
      default = "*:0/5";
      description = "How often to check and update DNS (systemd timer format, default: every 5 minutes)";
    };

    proxied = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Cloudflare proxy (orange cloud) for the domains";
    };
  };

  config =
    let
      cfg = config.snowflake.services.cloudflare-dyndns;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.domains != [ ];
          message = "snowflake.services.cloudflare-dyndns.domains must be set when enabled";
        }
      ];

      # Create agenix secret for the API token
      age.secrets.cloudflare-dyndns-token = {
        inherit (cfg.apiTokenFile) file;
      };

      # Configure Cloudflare Dynamic DNS service
      services.cloudflare-dyndns = {
        enable = true;
        apiTokenFile = config.age.secrets.cloudflare-dyndns-token.path;
        inherit (cfg) domains;
        inherit (cfg) frequency;
        inherit (cfg) proxied;
        ipv4 = true;
        ipv6 = false;
        deleteMissing = false;
      };
    };
}
