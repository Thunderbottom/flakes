# Copy this directory to `modules/hosts/<hostname>/` and rename `server`
# below to the machine's hostname. New files are picked up automatically
# (run `git add` first). `_disk-config.nix` is imported explicitly.
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.server.module =
    { lib, ... }:
    {
      imports = [
        nixos.server
        nixos.fail2ban

        ./_disk-config.nix
      ];

      system.stateVersion = "24.11";

      # NOTE: since we use disko to configure disks, the boot configuration
      # needs to be updated here. If you do not wish to use disko, you can move
      # this section to a `_hardware.nix`.
      boot = {
        initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "ehci_pci"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
        initrd.supportedFilesystems = [ ];
        kernelModules = [ ];
        kernelParams = [ "console=tty" ];
        loader.grub = {
          device = "/dev/sda";
          configurationLimit = 2;
        };
      };

      # Networking configuration
      networking = {
        nameservers = [ "1.1.1.1" ];
        interfaces.enp1s0 = {
          useDHCP = lib.mkDefault true;
          ipv6.addresses = [
            {
              address = "2a69:4f9:1c1d:91b::";
              prefixLength = 64;
            }
          ];
        };
        defaultGateway6 = {
          address = "fe80::1";
          interface = "enp1s0";
        };
        firewall.allowedTCPPorts = [
          80
          443
        ];
      };

      # The `server` profile logs in as `server`; override preferences for this host here.
      profile.fullName = "Server";
    };
}
