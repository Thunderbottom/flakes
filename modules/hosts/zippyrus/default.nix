{ nixos, ... }:
{
  configurations.nixos.zippyrus.module =
    { pkgs, ... }:
    {
      imports = [
        nixos.laptop
        nixos.lanzaboote
        nixos.docker
        nixos.gnome
        nixos.niri
        nixos.proton
        nixos.autofirma
        nixos.yubico
        nixos.amd-graphics
        nixos.nvidia-graphics
        nixos.wifi-profiles
        nixos.asus
        nixos.btrfs-standard-layout
        ./_hardware.nix
      ];

      hardware = {
        facter = {
          enable = true;
          reportPath = ./facter.json;
          detected.graphics.enable = false;
        };
      };

      boot.extraModprobeConfig = ''
        options cfg80211 ieee80211_regdom="ES"
      '';

      systemd.settings.Manager = {
        DefaultTimeoutStopSec = "10s";
      };

      environment.systemPackages = [ pkgs.obsidian ];

      hardware.nvidia.prime = {
        amdgpuBusId = "PCI:101:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
}
