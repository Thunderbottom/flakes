{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.services.qbittorrent-nox = {
    enable = lib.mkEnableOption "Enable qbittorrent-nox service configuration";

    package = lib.mkPackageOption pkgs "qbittorrent-nox" { };

    openFirewall = lib.mkOption {
      description = "Allow firewall access for qbittorrent-nox";
      type = lib.types.bool;
      default = false;
    };

    uiPort = lib.mkOption {
      description = "Web UI Port for qbittorrent-nox";
      type = lib.types.port;
      default = 8069;
    };

    torrentPort = lib.mkOption {
      description = "Torrenting port";
      type = with lib.types; nullOr port;
      default = 64211;
    };
  };

  config =
    let
      cfg = config.${namespace}.services.qbittorrent-nox;
    in
    lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts =
        lib.optional (cfg.openFirewall && cfg.torrentPort != null) cfg.torrentPort
        ++ lib.optional cfg.openFirewall cfg.uiPort;
      networking.firewall.allowedUDPPorts = lib.optional (
        cfg.openFirewall && cfg.torrentPort != null
      ) cfg.torrentPort;

      users.users.qbittorrent-nox = {
        isSystemUser = true;
        group = "media";
        home = "/var/lib/qbittorrent-nox";
      };

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
          rm -rf /var/lib/qbittorrent-nox/qBittorrent/config/vuetorrent
          ln -sf ${pkgs.${namespace}.vuetorrent} /var/lib/qbittorrent-nox/qBittorrent/config/vuetorrent

          if [[ ! -f /var/lib/qbittorrent-nox/qBittorrent/config/qBittorrent.conf ]]; then
            mkdir -p /var/lib/qbittorrent-nox/qBittorrent/config
            echo "Preferences\WebUI\HostHeaderValidation=false" >> /var/lib/qbittorrent-nox/qBittorrent/config/qBittorrent.conf
          fi
        '';
        serviceConfig = {
          User = "qbittorrent-nox";
          Group = "media";
          StateDirectory = "qbittorrent-nox";
          WorkingDirectory = "/var/lib/qbittorrent-nox";
          ExecStart = ''
            ${cfg.package}/bin/qbittorrent-nox ${
              lib.optionalString (cfg.torrentPort != null) "--torrenting-port=${toString cfg.torrentPort}"
            } \
              --webui-port=${toString cfg.uiPort} --profile=/var/lib/qbittorrent-nox
          '';
        };
      };
    };
}
