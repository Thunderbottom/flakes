{
  flake.modules.nixos.unifi-controller =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          networking.firewall.allowedTCPPorts = [ 8443 ];
          services.unifi = {
            enable = true;
            unifiPackage = pkgs.unifi;
            mongodbPackage = pkgs.mongodb-ce;
            # Limit memory to 256MB. Works well enough
            # for small, home-based controller deployments.
            maximumJavaHeapSize = 256;
            openFirewall = true;
          };
        }

      ];
    };
}
