{
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.hardware.graphics.amd.enable = lib.mkEnableOption "Enable AMD graphics configuration";

  config = lib.mkIf config.${namespace}.hardware.graphics.amd.enable {
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
