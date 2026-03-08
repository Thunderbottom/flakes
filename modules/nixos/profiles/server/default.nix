{ config, lib, ... }:
{
  # This is a PROFILE module - it groups related features for server hosts.
  # Profiles can be enabled with: snowflake.profile.server.enable = true
  #
  # Server profile focuses on:
  # - Performance and throughput over power efficiency
  # - Disabling laptop-specific services and hardware
  # - Consistent CPU frequency for predictable performance

  options.snowflake.profile.server.enable = lib.mkEnableOption "Server-specific configuration";

  config = lib.mkIf config.snowflake.profile.server.enable {
    # Automatically enable shared profile
    snowflake.profile.shared.enable = true;

    # Disable laptop power management explicitly
    powerManagement.powertop.enable = lib.mkForce false;
    services.thermald.enable = lib.mkForce false;

    # Disable NetworkManager - servers use dhcpcd or static config
    snowflake.networking.networkManager.enable = lib.mkForce false;

    # Server optimization: disable unnecessary hardware/services
    services.printing.enable = lib.mkForce false; # No printer on servers
    hardware.bluetooth.enable = lib.mkForce false; # No bluetooth on servers
    sound.enable = lib.mkDefault false; # No audio on servers (can override if needed)

    # Performance CPU governor for consistent throughput
    powerManagement.cpuFreqGovernor = "performance";

    # Btrfs maintenance for server root filesystem
    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };
  };
}
