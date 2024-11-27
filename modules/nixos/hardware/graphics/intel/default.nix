{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.hardware.graphics.intel = {
    enable = lib.mkEnableOption "Enable Intel graphics configuration";
    driver = lib.mkOption {
      type = lib.types.enum ["i915" "xe"];
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
        intel-compute-runtime
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        vaapiVdpau
        vpl-gpu-rt
      ];
    };

    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

    boot.initrd.kernelModules = [config.snowflake.hardware.graphics.intel.driver];
  };
}
