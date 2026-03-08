{ self, ... }:
{
  imports = [
    self.nixosModules.default
    self.inputs.agenix.nixosModules.age
    self.inputs.disko.nixosModules.disko
    self.inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Enable base shared configuration
  snowflake.profile.shared.enable = true;

  # Universal settings
  snowflake.stateVersion = "25.05";

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      self.overlays.default
    ];
    hostPlatform = "x86_64-linux";
  };
}
