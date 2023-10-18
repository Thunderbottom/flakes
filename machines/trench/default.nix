{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ../../modules/commons
    ../../modules/nixos/core-server.nix
    ../../modules/nixos/user-group.nix
    ../../modules/programs/nixvim
  ];

  environment.systemPackages = with pkgs; [
    nomad_1_6
    tailscale
  ];

  services = {
    unifi = {
      enable = true;
      unifiPackage = pkgs.unifi7;
      maximumJavaHeapSize = 256;
      openFirewall = true;
    };
  };

  system.stateVersion = "23.05";
}
