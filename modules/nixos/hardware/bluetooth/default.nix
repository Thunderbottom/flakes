{ config, lib, ... }:
{
  options.snowflake.hardware.bluetooth.enable = lib.mkEnableOption "Enable bluetooth hardware support";

  config = lib.mkIf config.snowflake.hardware.bluetooth.enable {
    # Enable bluetooth hardware.
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          # Enable battery charge levels for bluetooth devices.
          Experimental = true;
          KernelExperimental = true;
        };
      };
    };
  };
}
