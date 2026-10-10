{ nixos, ... }:
{
  flake.modules.nixos.qbittorrent-nox =
    { config, pkgs, ... }:
    let
      cfg = config.profile.services.qbittorrent;
      user = "qbittorrent-nox";
      group = "media";
      dataDir = "/var/lib/${user}";
    in
    {
      imports = [ nixos.backup-registry ];

      backups.qbittorrent-nox.paths = [ dataDir ];

      networking.firewall = {
        allowedTCPPorts = [
          cfg.torrentPort
          cfg.port
        ];
        allowedUDPPorts = [ cfg.torrentPort ];
      };

      users.users.${user} = {
        isSystemUser = true;
        inherit group;
        home = dataDir;
      };

      users.groups.${group} = { };

      systemd.services.qbittorrent-nox = {
        description = "qBittorrent-nox service";
        wants = [ "network-online.target" ];
        after = [
          "local-fs.target"
          "network-online.target"
          "nss-lookup.target"
        ];
        wantedBy = [ "multi-user.target" ];
        unitConfig.Documentation = "man:qbittorrent-nox(1)";
        # required for reverse proxying
        preStart = ''
          if [[ ! -f ${dataDir}/qBittorrent/config/qBittorrent.conf ]]; then
            mkdir -p ${dataDir}/qBittorrent/config
            echo "Preferences\WebUI\HostHeaderValidation=false" >> ${dataDir}/qBittorrent/config/qBittorrent.conf
          fi
        '';
        serviceConfig = {
          User = user;
          Group = group;
          Umask = "0002";
          StateDirectory = user;
          WorkingDirectory = dataDir;
          ExecStart = ''
            ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --torrenting-port=${toString cfg.torrentPort} \
              --webui-port=${toString cfg.port} --profile=${dataDir}
          '';
        };
      };
    };
}
