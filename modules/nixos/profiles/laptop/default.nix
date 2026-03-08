{ config, lib, ... }:
{
  # This is a PROFILE module - it groups related features for laptop hosts.
  # Profiles can be enabled with: snowflake.profile.laptop.enable = true
  #
  # Profiles are automatically imported via modules/default.nix recursive import.
  # No manual imports needed - just enable the profile option.

  options.snowflake.profile.laptop.enable = lib.mkEnableOption "Laptop-specific configuration";

  config = lib.mkIf config.snowflake.profile.laptop.enable {
    # Automatically enable shared profile
    snowflake.profile.shared.enable = true;

    # Power management for battery efficiency on portable devices
    powerManagement.powertop.enable = true;
    services.thermald.enable = true;

    # Wireless networking
    snowflake.networking.networkManager.enable = true;

    # Btrfs maintenance for laptop root filesystem
    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };

    # Common laptop user configuration
    snowflake.user = {
      enable = lib.mkDefault true;
      username = lib.mkDefault "chnmy";
      description = lib.mkDefault "Chinmay D. Pai";
      extraGroups = lib.mkDefault [ "video" ];
      # Password files must be set per-host (don't have defaults)
    };
  };
}
