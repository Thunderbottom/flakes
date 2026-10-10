{
  flake.modules.nixos.amd-graphics =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        hardware.amdgpu.initrd.enable = lib.mkDefault true;

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
    };
}
