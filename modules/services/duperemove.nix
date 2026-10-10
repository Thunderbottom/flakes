{
  flake.modules.nixos.duperemove =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    {
      config =
        let
          cfg = {
            package = pkgs.duperemove;
            hashfile = "/storage/duperemove.hash";
            paths = [ "/storage/media" ];
            extraArgs = "-dr";
            systemdInterval = "daily";
          };
        in
        {
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
    };
}
