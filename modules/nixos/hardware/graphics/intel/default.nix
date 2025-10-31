{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.hardware.graphics.intel = {
    enable = lib.mkEnableOption "Enable Intel graphics configuration";
    computeRuntime = lib.mkOption {
      description = "intel-compute-runtime variant to use";
      type = lib.types.package;
      default = pkgs.intel-compute-runtime;
    };
    driver = lib.mkOption {
      type = lib.types.enum [
        "i915"
        "xe"
      ];
      description = "Whether to use i915 or experimental xe driver";
      default = "i915";
    };
  };

  config = lib.mkIf config.snowflake.hardware.graphics.intel.enable {
    # Add opengl hardware support.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        config.snowflake.hardware.graphics.intel.computeRuntime
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        libva-vdpau-driver
        vpl-gpu-rt
      ];
    };

    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

    boot.initrd.kernelModules = [ config.snowflake.hardware.graphics.intel.driver ];
  };
}
