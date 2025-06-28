{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.services.qbittorrent-nox = {
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

    ui = {
      flood = {
        enable = lib.mkEnableOption "Enable flood Web UI for qbittorrent-nox";

        port = lib.mkOption {
          description = "Flood web UI port";
          type = lib.types.port;
          default = 8282;
        };

        host = lib.mkOption {
          description = "Interfaces that flood should listen on";
          type = lib.types.str;
          default = "0.0.0.0";
        };
      };

      vuetorrent.enable = lib.mkEnableOption "Enable VueTorrent Web UI for qbittorrent-nox";
    };
  };

  config =
    let
      cfg = config.snowflake.services.qbittorrent-nox;
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          networking.firewall.allowedTCPPorts =
            lib.optional (cfg.openFirewall && cfg.torrentPort != null) cfg.torrentPort
            ++ lib.optional cfg.openFirewall cfg.uiPort
            ++ lib.optional (cfg.openFirewall && cfg.flood.enable) cfg.flood.port;
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
              ${lib.optionalString cfg.ui.vuetorrent.enable ''
                rm -rf /var/lib/qbittorrent-nox/qBittorrent/config/vuetorrent
                ln -sf ${pkgs.vuetorrent}/share/vuetorrent /var/lib/qbittorrent-nox/qBittorrent/config/vuetorrent
              ''}

              if [[ ! -f /var/lib/qbittorrent-nox/qBittorrent/config/qBittorrent.conf ]]; then
                mkdir -p /var/lib/qbittorrent-nox/qBittorrent/config
                echo "Preferences\WebUI\HostHeaderValidation=false" >> /var/lib/qbittorrent-nox/qBittorrent/config/qBittorrent.conf
              fi
            '';
            serviceConfig = {
              User = "qbittorrent-nox";
              Group = "media";
              # NOTE: Required for arr stack to symlink files
              # Allows the group to have r+w on files
              Umask = "0002";
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
        }

        (lib.mkIf cfg.ui.flood.enable {
          environment.systemPackages = with pkgs; [
            flood
            mediainfo
          ];

          systemd.services.flood = {
            description = "Flood WebUI for qbittorrent-nox";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            requires = [ "network-online.target" ];

            serviceConfig = {
              Type = "simple";
              User = "qbittorrent-nox";
              Group = "media";

              ExecStart = ''
                ${pkgs.flood}/bin/flood \
                  --port ${toString cfg.ui.flood.port} \
                  --host ${cfg.ui.flood.host}
              '';
            };
          };
        })
      ]
    );
}
