{
  flake.modules.nixos.nvidia-graphics =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = [
            pkgs.nvidia-vaapi-driver
          ];
        };

        hardware.nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.latest;
          modesetting.enable = true;
          nvidiaSettings = true;
          dynamicBoost.enable = true;
          open = true;
          powerManagement.enable = true;

          # In PRIME offload mode, apps run on the iGPU by default, so LIBVA should
          # use the iGPU's driver (set by the AMD/Intel graphics module).
          # GBM_BACKEND and __GLX_VENDOR_LIBRARY_NAME are set by the nvidia-offload
          # wrapper command (enableOffloadCmd) only for apps explicitly run on the dGPU.
          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
          };
        };

        boot.blacklistedKernelModules = [ "nouveau" ];
        boot.kernelParams = [
          "acpi_backlight=native"
          # Prevent NVIDIA from registering its own backlight handler in hybrid mode,
          # letting amdgpu own brightness control via amdgpu_bl1.
          "nvidia.NVreg_EnableBacklightHandler=0"
          # Required for the dGPU to power down during suspend on hardware that only
          # supports s2idle (no S3). Without this, sleep battery drain is much higher.
          "nvidia.NVreg_EnableS0ixPowerManagement=1"
        ];

        services.xserver.videoDrivers = [ "nvidia" ];
      };
    };
}
