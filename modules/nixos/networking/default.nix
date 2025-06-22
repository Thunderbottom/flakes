{
  config,
  lib,
  ...
}:
let
  cfg = config.snowflake.networking;

  # Helper function to create a standard WiFi profile
  mkWifiProfile = ssid: psk: {
    connection = {
      id = ssid;
      type = "wifi";
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = {
      addr-gen-mode = "stable-privacy";
      method = "auto";
    };
    wifi = {
      mode = "infrastructure";
      inherit ssid;
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      inherit psk;
    };
  };
in
{
  options.snowflake.networking = {
    iwd.enable = lib.mkEnableOption "Enable iwd backend for network manager";
    networkd.enable = lib.mkEnableOption "Enable systemd network management daemon";
    networkManager.enable = lib.mkEnableOption "Enable network-manager";
    resolved.enable = lib.mkEnableOption "Enable systemd-resolved";
    firewall.enable = lib.mkEnableOption "Enable system firewall";

    wifiProfiles = {
      enable = lib.mkEnableOption "Enable WiFi profile management";

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = "List of environment files containing WiFi credentials";
      };

      networks = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          "My Network" = "$MY_NETWORK_PSK";
          "Office WiFi" = "$OFFICE_PSK";
        };
        description = "Map of WiFi SSIDs to their PSK environment variables";
      };

      customProfiles = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        example = {
          "Enterprise-Network" = {
            connection = {
              id = "Enterprise Network";
              type = "wifi";
            };
            ipv4.method = "auto";
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "Enterprise WiFi";
            };
            wifi-security = {
              key-mgmt = "wpa-eap";
              eap = "peap";
              identity = "$ENTERPRISE_USERNAME";
              password = "$ENTERPRISE_PASSWORD";
            };
          };
          "Guest-Hotspot" = {
            connection = {
              id = "Guest Hotspot";
              type = "wifi";
            };
            ipv4.method = "auto";
            ipv6.method = "ignore";
            wifi = {
              mode = "infrastructure";
              ssid = "Guest-Network";
            };
            # Open network with no security
          };
        };
        description = ''
          Additional custom NetworkManager profiles that don't follow the standard template.
          Use this for networks requiring special configuration like enterprise authentication,
          static IP addresses, or custom security settings.
        '';
      };
    };
  };

  config = lib.mkMerge [
    {
      # Enable the network firewall by default.
      networking.firewall.enable = lib.mkDefault config.snowflake.networking.firewall.enable;
      # use nftables for firewall
      networking.nftables.enable = true;
    }

    (lib.mkIf config.snowflake.networking.iwd.enable {
      networking.wireless.iwd = {
        enable = true;
        settings = {
          General = {
            EnableNetworkConfiguration = true;
          };
          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 300;
            NameResolvingService = "systemd";
          };
          Settings = {
            AutoConnect = true;
          };
          Scan.DisablePeriodicScan = true;
        };
      };
    })

    (lib.mkIf config.snowflake.networking.networkManager.enable {
      systemd.services.NetworkManager-wait-online.enable = false;

      networking.networkmanager = {
        enable = lib.mkDefault true;
        # Disable Wifi powersaving
        wifi.powersave = false;
        wifi.backend = if config.snowflake.networking.iwd.enable then "iwd" else "wpa_supplicant";
      };

      snowflake.user.extraGroups = [ "networkmanager" ];

      services.resolved = {
        inherit (config.snowflake.networking.resolved) enable;
      };
    })

    (lib.mkIf cfg.wifiProfiles.enable {
      networking.networkmanager.ensureProfiles =
        let
          # Generate profiles from the networks map
          generatedProfiles = builtins.listToAttrs (
            lib.mapAttrsToList (ssid: psk: {
              name = builtins.replaceStrings [ " " "." ":" ] [ "-" "-" "-" ] ssid;
              value = mkWifiProfile ssid psk;
            }) cfg.wifiProfiles.networks
          );
        in
        {
          inherit (cfg.wifiProfiles) environmentFiles;
          profiles = generatedProfiles // cfg.wifiProfiles.customProfiles;
        };
    })

    (lib.mkIf config.snowflake.networking.networkd.enable {
      systemd.network.enable = true;

      systemd.services = {
        systemd-networkd-wait-online.enable = false;
        systemd-networkd.restartIfChanged = false;
        firewall.restartIfChanged = false;
      };

      networking.interfaces = {
        enp1s0.useDHCP = true;
        wlan0.useDHCP = true;
      };
    })
  ];
}
