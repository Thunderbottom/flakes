{
  config,
  lib,
  ...
}: {
  options.snowflake.services.fail2ban = {
    enable = lib.mkEnableOption "Enable fail2ban service";

    extraIgnoreIPs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of IPs to ignore for fail2ban alongside the default local subnets and loopback";
    };
  };

  config = let
    cfg = config.snowflake.services.fail2ban;
  in
    lib.mkIf cfg.enable {
      services.fail2ban = {
        enable = true;
        maxretry = 3;
        banaction-allports = "iptables-allports";

        bantime-increment = {
          enable = true;
          maxtime = "168h";
          factor = "4";
        };

        ignoreIP =
          [
            "192.168.69.0/16"
            "172.16.0.0/12"
            "127.0.0.0/8"
          ]
          ++ cfg.extraIgnoreIPs;

        jails = {
          DEFAULT = {
            settings = {
              blocktype = "DROP";
              bantime = lib.mkDefault "6h";
              findtime = "6h";
            };
          };

          sshd = {
            settings = {
              enabled = true;
              findtime = "1d";
              maxretry = 4;
              mode = "aggressive";
              port = "ssh";
              logpath = "%(sshd_log)s";
              backend = "%(sshd_backend)s";
            };
          };

          port-scan = {
            settings = {
              filter = "port-scan";
              action = "iptables-allports[name=port-scan]";
              bantime = 86400;
              maxretry = 2;
            };
          };
        };
      };
    };
}
