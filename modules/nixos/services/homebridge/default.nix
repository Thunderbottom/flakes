{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.services.homebridge.enable =
    lib.mkEnableOption "Enable homebridge service for Apple HomeKit";

  config = lib.mkIf config.${namespace}.services.homebridge.enable {
    networking.firewall = lib.mkIf config.networking.firewall.enable {
      allowedTCPPorts = [
        5353
        8581
        51241
      ];
      allowedTCPPortRanges = [
        {
          from = 52100;
          to = 52150;
        }
      ];
      allowedUDPPorts = [
        5353
        8581
        51241
      ];
      allowedUDPPortRanges = [
        {
          from = 52100;
          to = 52150;
        }
      ];
    };

    virtualisation.oci-containers.containers.homebridge = {
      image = "docker.io/homebridge/homebridge:latest";
      volumes = [ "/var/lib/homebridge:/homebridge" ];
      environment = {
        TZ = config.time.timeZone;
      };
      ports = [ "8581:8581" ];
      extraOptions = [
        "--privileged"
        "--net=host"
        # For podman
        "label=io.containers.autoupdate=registry"
      ];
    };
  };
}
