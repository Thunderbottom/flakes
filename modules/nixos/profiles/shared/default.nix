{ config, lib, ... }:
{
  # This is a PROFILE module - contains truly universal settings for ALL hosts.
  # Profiles can be enabled with: snowflake.profile.shared.enable = true
  #
  # This profile is minimal by design - only include what EVERY host needs.
  # Host-type-specific settings belong in laptop/server/desktop profiles.

  options.snowflake.profile.shared.enable = lib.mkEnableOption "Shared base configuration for all hosts";

  config = lib.mkIf config.snowflake.profile.shared.enable {
    # Truly universal settings only
    snowflake = {
      # Firewall enabled on all hosts by default
      networking.firewall.enable = lib.mkDefault true;

      # Resolved for DNS (can be overridden if needed)
      networking.resolved.enable = lib.mkDefault true;
    };
  };
}
