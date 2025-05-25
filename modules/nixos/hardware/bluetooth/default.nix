{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.hardware.bluetooth.enable =
    lib.mkEnableOption "Enable bluetooth hardware support";

  config = lib.mkIf config.${namespace}.hardware.bluetooth.enable {
    # Enable bluetooth hardware.
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          # Enable battery charge levels for bluetooth devices.
          Experimental = true;
          KernelExperimental = true;
        };
      };
    };

    # Add support for Bluetooth LE
    ${namespace}.extraPackages = [ pkgs.liblc3 ];
  };
}
