{
  desktop,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      ./fonts.nix
      ../services/pipewire.nix
    ]
    ++ lib.optional (builtins.pathExists (./. + "/${desktop}.nix")) ./${desktop}.nix;

  boot = {
    plymouth.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  programs = {
    adb.enable = true;
    ssh.startAgent = true;
    dconf.enable = true;
  };

  # Disable xterm
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.desktopManager.xterm.enable = false;
  # Add udev rules for adb
  services.udev.packages = with pkgs; [android-udev-rules];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
