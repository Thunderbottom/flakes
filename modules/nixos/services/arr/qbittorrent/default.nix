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

    user = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent-nox";
      description = "User account under which qbittorrent-nox runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "media";
      description = "Group under which qbittorrent-nox runs";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/qbittorrent-nox";
      description = "The directory where qbittorrent-nox stores its data files";
    };

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
          snowflake.meta.ports.list = [
            cfg.torrentPort
            cfg.uiPort
          ]
          ++ lib.optional cfg.ui.flood.enable cfg.ui.flood.port;

          snowflake.services.backups.config.qbittorrent-nox.paths = [ cfg.dataDir ];

          networking.firewall.allowedTCPPorts =
            lib.optional (cfg.openFirewall && cfg.torrentPort != null) cfg.torrentPort
            ++ lib.optional cfg.openFirewall cfg.uiPort
            ++ lib.optional (cfg.openFirewall && cfg.ui.flood.enable) cfg.ui.flood.port;
          networking.firewall.allowedUDPPorts = lib.optional (
            cfg.openFirewall && cfg.torrentPort != null
          ) cfg.torrentPort;

          users.users.${cfg.user} = {
            isSystemUser = true;
            inherit (cfg) group;
            home = cfg.dataDir;
          };

          users.groups.${cfg.group} = lib.mkIf (cfg.group == "media") { };

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
                rm -rf ${cfg.dataDir}/qBittorrent/config/vuetorrent
                ln -sf ${pkgs.vuetorrent}/share/vuetorrent ${cfg.dataDir}/qBittorrent/config/vuetorrent
              ''}

              if [[ ! -f ${cfg.dataDir}/qBittorrent/config/qBittorrent.conf ]]; then
                mkdir -p ${cfg.dataDir}/qBittorrent/config
                echo "Preferences\WebUI\HostHeaderValidation=false" >> ${cfg.dataDir}/qBittorrent/config/qBittorrent.conf
              fi
            '';
            serviceConfig = {
              User = cfg.user;
              Group = cfg.group;
              Umask = "0002";
              StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/${cfg.user}") cfg.user;
              WorkingDirectory = cfg.dataDir;
              ExecStart = ''
                ${cfg.package}/bin/qbittorrent-nox ${
                  lib.optionalString (cfg.torrentPort != null) "--torrenting-port=${toString cfg.torrentPort}"
                } \
                  --webui-port=${toString cfg.uiPort} --profile=${cfg.dataDir}
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
              User = cfg.user;
              Group = cfg.group;

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
