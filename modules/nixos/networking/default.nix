{
  config,
  lib,
  ...
}: {
  options.snowflake.networking = {
    iwd.enable = lib.mkEnableOption "Enable iwd backend for network manager";
    networkd.enable = lib.mkEnableOption "Enable systemd network management daemon";
    networkManager.enable = lib.mkEnableOption "Enable network-manager";
    resolved.enable = lib.mkEnableOption "Enable systemd-resolved";
    firewall.enable = lib.mkEnableOption "Enable system firewall";
  };

  config = lib.mkMerge [
    {
      # Enable the network firewall by default.
      networking.firewall.enable = config.snowflake.networking.firewall.enable;
      # use nftables for firewall
      networking.nftables.enable = true;
    }

    (lib.mkIf config.snowflake.networking.iwd.enable {
      networking.wireless.iwd = {
        enable = true;
        settings = {
          General = {
            AddressRandomization = "network";
            AddressRandomizationRange = "full";
            EnableNetworkConfiguration = true;
            RoamRetryInterval = 20;
          };
          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 300;
          };
          Settings = {
            AutoConnect = true;
          };
          # Prioritize connection to 5GHz.
          Rank.BandModifier5Ghz = 2.0;
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
        wifi.backend =
          if config.snowflake.networking.iwd.enable
          then "iwd"
          else "wpa_supplicant";
      };

      snowflake.user.extraGroups = ["networkmanager"];

      services.resolved = {
        enable = config.snowflake.networking.resolved.enable;
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
