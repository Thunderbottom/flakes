{
  config,
  lib,
  ...
}:
let
  cfg = config.snowflake.services.qui;
in
{
  options.snowflake.services.qui = {
    enable = lib.mkEnableOption "Enable qui web UI for qbittorrent";

    port = lib.mkOption {
      type = lib.types.port;
      default = 7476;
      description = "Port qui listens on";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Host address qui listens on";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open firewall port for qui";
    };

    secretFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to a file containing the session secret (generate with: openssl rand -hex 32)";
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional qui settings (see https://github.com/autobrr/qui)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.qui = {
      enable = true;
      inherit (cfg) secretFile openFirewall;
      settings = {
        host = cfg.host;
        port = cfg.port;
      } // cfg.extraSettings;
    };

    snowflake.meta.ports.list = [ cfg.port ];

    snowflake.services.backups.config.qui.paths = [
      "/var/lib/${config.services.qui.user}"
    ];
  };
}
