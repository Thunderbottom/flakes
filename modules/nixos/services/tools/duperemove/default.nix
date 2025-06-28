{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.snowflake.services.duperemove = {
    enable = lib.mkEnableOption "Enable periodic filesystem de-duplication with duperemove";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.duperemove;
      defaultText = lib.literalExpression "pkgs.duperemove";
      description = "The duperemove package to use";
    };

    hashfile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      defaultText = lib.literalExpression "null";
      description = ''
        (Optional) Path to Hash file used for storing filesystem hashes. Significantly speeds up subsequent runs.
      '';
    };

    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      defaultText = lib.literalExpression "[]";
      description = ''
        Paths to deduplicate. If you're using NixOS, the Nix Store can be deduplicated by nix itself. These paths
        should point to other directories in that case for ex. /home/my-user
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.str;
      default = "";
      defaultText = lib.literalExpression "\"\"";
      description = "Extra arguments to pass to duperemove. Example: -d -r";
    };

    systemdInterval = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      defaultText = lib.literalExpression "daily";
      description = "See systemd OnCalendar options (eg. daily, weekly)";
    };
  };

  config =
    let
      cfg = config.snowflake.services.duperemove;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = builtins.length cfg.paths > 0;
          message = "duperemove: at least one path must be specified";
        }
      ];

      environment.systemPackages = [ cfg.package ];
      systemd.packages = [ cfg.package ];

      systemd.services.duperemove = {
        description = "Duperemove - filesystem de-duplicater";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = builtins.concatStringsSep " " (
            [ "${lib.getExe cfg.package} ${cfg.extraArgs}" ]
            ++ lib.lists.optional (cfg.hashfile != null) "--hashfile=${cfg.hashfile}"
            ++ cfg.paths
          );
        };
      };

      systemd.timers.duperemove = {
        description = "Run duperemove and de-duplicate filesystem on a schedule";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = true;
          OnCalendar = cfg.systemdInterval;
        };
      };
    };
}
