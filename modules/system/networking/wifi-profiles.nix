{
  flake.modules.nixos.wifi-profiles =
    {
      config,
      lib,
      ...
    }:
    let
      networks = config.profile.wifi.networks;

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
      config = {
        age.secrets.network-manager-psk.file = config.profile.secrets.network-manager.passphrase.file;

        networking.networkmanager.ensureProfiles =
          let
            generatedProfiles = builtins.listToAttrs (
              lib.mapAttrsToList (ssid: psk: {
                name = builtins.replaceStrings [ " " "." ":" ] [ "-" "-" "-" ] ssid;
                value = mkWifiProfile ssid psk;
              }) networks
            );
          in
          {
            environmentFiles = [ config.age.secrets.network-manager-psk.path ];
            profiles = generatedProfiles;
          };
      };
    };
}
