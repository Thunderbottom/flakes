{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    ../../system/hardware/boot.nix
    ../../system/hardware/initrd-luks.nix
    ../../system/services/nginx.nix
    ../../system/services/nomad.nix
    ../../system/services/gitea.nix
    ../../system/services/maych-in.nix
    ../../system/services/vaultwarden.nix
    ../../system/services/unifi.nix
  ];

  environment.systemPackages = with pkgs; [tailscale];

  networking = {
    hostName = "trench";
    nameservers = ["1.1.1.1"];
    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault false;
    interfaces.enp6s0 = {
      useDHCP = lib.mkDefault true;
      wakeOnLan.enable = true;
    };
    networkmanager.enable = true;
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = false;
  };

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "ehci_pci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      luks.devices."root".device = "/dev/disk/by-uuid/e70bfc3c-1147-4af7-9bae-69f70146953f";
    };
    kernelModules = ["kvm-amd"];
  };

  services.netdata.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@"];
      neededForBoot = true; # required
    };

    "/home" = {
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@home"];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@snapshots"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@log"];
    };

    "/etc/nixos" = {
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@nixos-config"];
    };

    "/var/cache" = {
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@cache"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1C6C-122C";
      fsType = "vfat";
    };
  };
  swapDevices = [];
}
