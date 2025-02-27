{
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.hardware.bluetooth.enable = lib.mkEnableOption "Enable bluetooth hardware support";

  config = lib.mkIf config.${namespace}.hardware.bluetooth.enable {
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
