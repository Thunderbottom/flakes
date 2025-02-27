{
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.hardware.graphics.nvidia.enable = lib.mkEnableOption "Enable Nvidia graphics configuration";

  config = lib.mkIf config.${namespace}.hardware.graphics.nvidia.enable {
    # Add opengl hardware support.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      nvidiaSettings = true;
      dynamicBoost.enable = true;

      powerManagement.enable = true;
      powerManagement.finegrained = true;

      open = false;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:101:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    environment.sessionVariables.LIBVA_DRIVER_NAME = lib.mkDefault "nvidia";
    environment.variables.KWIN_DRM_ALLOW_NVIDIA_COLORSPACE = "1";

    boot.blacklistedKernelModules = ["nouveau"];
    boot.kernelParams = ["nvidia-drm.modeset=1" "nvidia.NVreg_EnableS0ixPowerManagement=1"];

    systemd.services = {
      nvidia-hibernate = {
        before = ["systemd-suspend-then-hibernate.service"];
        wantedBy = ["suspend-then-hibernate.target"];
      };

      nvidia-suspend = {
        before = ["systemd-hybrid-sleep.service"];
        wantedBy = ["hybrid-sleep.target"];
      };

      nvidia-resume = {
        after = ["systemd-suspend-then-hibernate.service" "systemd-hybrid-sleep.service"];
        wantedBy = ["post-resume.target"];
      };
    };
  };
}
