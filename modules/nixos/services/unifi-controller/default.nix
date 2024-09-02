{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.services.unifi-controller.enable = lib.mkEnableOption "Enable Unifi controller service for Unifi devices";

  config = lib.mkIf config.snowflake.services.unifi-controller.enable {
    networking.firewall.allowedTCPPorts = [ 8443 ];
    services.unifi = {
      enable = true;
      unifiPackage = pkgs.unifi8;
      # Limit memory to 256MB. Works well enough
      # for small, home-based controller deployments.
      maximumJavaHeapSize = 256;
      openFirewall = true;
    };
  };
}
