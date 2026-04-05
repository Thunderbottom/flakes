{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.hardware.graphics.amd.enable =
    lib.mkEnableOption "Enable AMD graphics configuration";

  config = lib.mkIf config.snowflake.hardware.graphics.amd.enable {
    hardware.amdgpu.initrd.enable = lib.mkDefault true;

    # Add opengl hardware support.
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva
        libva-vdpau-driver
        libvdpau-va-gl
        mesa
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    services.xserver.videoDrivers = [ "amdgpu" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
