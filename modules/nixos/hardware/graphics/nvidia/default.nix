{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.hardware.graphics.nvidia = {
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

  config = lib.mkIf config.snowflake.hardware.graphics.nvidia.enable {
    assertions = [
      {
        assertion = config.snowflake.hardware.graphics.nvidia.busIDs.nvidia != "";
        message = "You need to define a bus ID for your Nvidia GPU. To learn how to find the bus ID, see https://wiki.nixos.org/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29.";
      }
      {
        assertion =
          config.snowflake.hardware.graphics.nvidia.busIDs.intel != ""
          || config.snowflake.hardware.graphics.nvidia.busIDs.amd != "";
        message = "You need to define a bus ID for your non-Nvidia GPU. To learn how to find your bus ID, see https://wiki.nixos.org/wiki/Nvidia#Configuring_Optimus_PRIME:_Bus_ID_Values_.28Mandatory.29.";
      }
    ];
    # Add opengl hardware support.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.libva-vdpau-driver
        pkgs.nvidia-vaapi-driver
      ];
    };

    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    hardware.nvidia = {
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      package =
        let
          base = config.boot.kernelPackages.nvidiaPackages.latest;
          cachyos-nvidia-patch = pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
            sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
          };

          # Patch the appropriate driver based on config.hardware.nvidia.open
          driverAttr = if config.hardware.nvidia.open then "open" else "bin";
        in
        base
        // {
          ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
          });
        };
      modesetting.enable = true;
      nvidiaSettings = config.snowflake.desktop.enable;
      dynamicBoost.enable = true;

      powerManagement.enable = true;
      powerManagement.finegrained = true;

      open = true;

      # In PRIME offload mode, apps run on the iGPU by default, so LIBVA should
      # use the iGPU's driver (set by the AMD/Intel graphics module).
      # GBM_BACKEND and __GLX_VENDOR_LIBRARY_NAME are set by the nvidia-offload
      # wrapper command (enableOffloadCmd) only for apps explicitly run on the dGPU.
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = config.snowflake.hardware.graphics.nvidia.busIDs.amd;
        nvidiaBusId = config.snowflake.hardware.graphics.nvidia.busIDs.nvidia;
      };
    };

    environment.variables.KWIN_DRM_ALLOW_NVIDIA_COLORSPACE = "1";

    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_EnableGpuFirmware=0"
    ];

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
          ExecStart = "${pkgs.procps}/bin/pkill -f -STOP ${pkgs.gnome-shell}/bin/gnome-shell";
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
          ExecStart = "${pkgs.procps}/bin/pkill -f -CONT ${pkgs.gnome-shell}/bin/gnome-shell";
        };
      };
    };
  };
}
