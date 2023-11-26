{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ../../modules/commons
    ../../modules/nixos/core-server.nix
    ../../modules/nixos/user-group.nix
    ../../modules/programs/nixvim
    ../../modules/programs/nomad
    ../../modules/programs/gitea
  ];

  environment.systemPackages = with pkgs; [tailscale];

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
