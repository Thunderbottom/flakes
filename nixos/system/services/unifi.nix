{pkgs, ...}: {
  services = {
    unifi = {
      enable = true;
      unifiPackage = pkgs.unifi8;
      maximumJavaHeapSize = 256;
      openFirewall = true;
    };
  };
}
