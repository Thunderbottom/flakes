{ nixos, ... }:
{
  configurations.nixos.donkpad.module =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      imports = [
        nixos.laptop
        nixos.docker
        nixos.gnome
        nixos.steam
        nixos.intel-graphics
        nixos.btrfs-standard-layout
        ./_hardware.nix
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
      ];

      services.fprintd.enable = true;

      # The old iGPU needs the legacy compute runtime.
      hardware.graphics.extraPackages = [ pkgs.intel-compute-runtime-legacy1 ];

      networking = {
        wireless.iwd = {
          enable = true;
          settings = {
            General.EnableNetworkConfiguration = true;
            Network = {
              EnableIPv6 = true;
              RoutePriorityOffset = 300;
              NameResolvingService = "systemd";
            };
            Settings.AutoConnect = true;
            Scan.DisablePeriodicScan = true;
          };
        };
        networkmanager.wifi.backend = "iwd";
      };
    };
}
