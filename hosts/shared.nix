{ self, ... }:
{
  imports = [
    self.nixosModules.default
    self.inputs.agenix.nixosModules.age
    self.inputs.disko.nixosModules.disko
    self.inputs.lanzaboote.nixosModules.lanzaboote
  ];

  snowflake = {
    stateVersion = "25.05";
    networking.firewall.enable = true;
    networking.networkManager.enable = true;
    networking.resolved.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
    ];
    hostPlatform = "x86_64-linux";
  };

  # Enable weekly btrfs auto-scrub.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  # Power management, enable powertop and thermald.
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
}
