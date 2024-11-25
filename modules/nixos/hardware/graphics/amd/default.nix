{
  config,
  lib,
  ...
}: {
  options.snowflake.hardware.graphics.amd.enable = lib.mkEnableOption "Enable AMD graphics configuration";

  config = lib.mkIf config.snowflake.hardware.graphics.amd.enable {
    hardware.amdgpu.initrd.enable = lib.mkDefault true;

    # Add opengl hardware support.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.sessionVariables.LIBVA_DRIVER_NAME = "radeonsi";

    boot.initrd.kernelModules = ["amdgpu"];
  };
}
