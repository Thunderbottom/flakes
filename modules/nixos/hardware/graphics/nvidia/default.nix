{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.hardware.graphics.nvidia = {
    enable = lib.mkEnableOption "Enable Nvidia graphics configuration";
    busIDs = {
      amd = lib.mkOption {
        description = "The bus ID for your integrated AMD GPU. If you don't have an AMD GPU, you can leave this blank.";
        type = lib.types.str;
        example = "PCI:101:0:0";
        default = "";
      };
      intel = lib.mkOption {
        description = "The bus ID for your integrated Intel GPU. If you don't have an Intel GPU, you can leave this blank.";
        type = lib.types.str;
        example = "PCI:14:0:0";
        default = "";
      };
      nvidia = lib.mkOption {
        description = "The bus ID for your Nvidia GPU";
        type = lib.types.str;
        example = "PCI:1:0:0";
        default = "";
      };
    };
  };

  config = lib.mkIf config.${namespace}.hardware.graphics.nvidia.enable {
    assertions = [
      {
        assertion = config.${namespace}.hardware.graphics.nvidia.busIDs.nvidia != "";
        message = "You need to define a bus ID for your Nvidia GPU. To learn how to find the bus ID, see https://wiki.nixos.org/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29.";
      }
      {
        assertion =
          config.${namespace}.hardware.graphics.nvidia.busIDs.intel != ""
          || config.${namespace}.hardware.graphics.nvidia.busIDs.amd != "";
        message = "You need to define a bus ID for your non-Nvidia GPU. To learn how to find your bus ID, see https://wiki.nixos.org/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29.";
      }
    ];
    # Add opengl hardware support.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.vaapiVdpau
        pkgs.nvidia-vaapi-driver
      ];
    };

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      nvidiaSettings = config.${namespace}.desktop.enable;
      dynamicBoost.enable = true;

      powerManagement.enable = true;
      powerManagement.finegrained = true;

      open = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = config.${namespace}.hardware.graphics.nvidia.busIDs.amd;
        nvidiaBusId = config.${namespace}.hardware.graphics.nvidia.busIDs.nvidia;
      };
    };

    environment.sessionVariables.LIBVA_DRIVER_NAME = lib.mkDefault "nvidia";
    environment.variables.KWIN_DRM_ALLOW_NVIDIA_COLORSPACE = "1";

    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];

    services.xserver.videoDrivers = [ "nvidia" ];
    systemd = {
      services."gnome-suspend" = {
        description = "suspend gnome shell";
        before = [
          "systemd-suspend.service"
          "systemd-hibernate.service"
          "nvidia-suspend.service"
          "nvidia-hibernate.service"
        ];
        wantedBy = [
          "systemd-suspend.service"
          "systemd-hibernate.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''${pkgs.procps}/bin/pkill -f -STOP ${pkgs.gnome-shell}/bin/gnome-shell'';
        };
      };
      services."gnome-resume" = {
        description = "resume gnome shell";
        after = [
          "systemd-suspend.service"
          "systemd-hibernate.service"
          "nvidia-resume.service"
        ];
        wantedBy = [
          "systemd-suspend.service"
          "systemd-hibernate.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''${pkgs.procps}/bin/pkill -f -CONT ${pkgs.gnome-shell}/bin/gnome-shell'';
        };
      };
    };
  };
}
