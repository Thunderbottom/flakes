{
  flake.modules.nixos.fail2ban =
    {
      config,
      lib,
      ...
    }:
    {
      # Services add a jail and its filter with `fail2ban.<name>`.
      options.fail2ban = lib.mkOption {
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                failregex = lib.mkOption { type = lib.types.lines; };
                unit = lib.mkOption {
                  type = lib.types.str;
                  default = "${name}.service";
                };
              };
            }
          )
        );
      };

      config = {
        environment.etc = lib.mapAttrs' (
          name: jail:
          lib.nameValuePair "fail2ban/filter.d/${name}.conf" {
            text = ''
              [INCLUDES]
              before = common.conf

              [Definition]
              failregex = ${jail.failregex}
              ignoreregex =
              journalmatch = _SYSTEMD_UNIT=${jail.unit}
            '';
          }
        ) config.fail2ban;

        services.fail2ban = {
          enable = true;
          maxretry = 3;
          banaction-allports = "iptables-allports";

          bantime-increment = {
            enable = true;
            maxtime = "168h";
            factor = "4";
          };

          ignoreIP = [
            "172.16.0.0/12"
            "127.0.0.0/8"
          ];

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

          }
          // lib.mapAttrs (name: _: {
            enabled = true;
            filter = name;
          }) config.fail2ban;
        };
      };
    };
}
