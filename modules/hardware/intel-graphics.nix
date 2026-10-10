{
  flake.modules.nixos.intel-graphics =
    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          libvdpau-va-gl
          libva-vdpau-driver
          vpl-gpu-rt
        ];
      };

      environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

      boot.initrd.kernelModules = [ "i915" ];
    };
}
