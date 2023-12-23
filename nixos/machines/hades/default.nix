{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
    ../../system/hardware/boot.nix
    ../../system/hardware/yubico.nix
  ];

  networking = {
    hostName = "hades";
    useDHCP = lib.mkDefault false;
    interfaces.wlan0.useDHCP = lib.mkDefault false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Use iwd instead of wpa_supplicant
      wifi.powersave = false;
    };
    wireless.iwd.enable = true;
    firewall.enable = false;
  };

  services.mullvad-vpn.enable = true;
  hardware.bluetooth.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod"];
      luks.devices."cryptroot".device = "/dev/disk/by-uuid/312b4d84-64dc-4721-9be3-bb0148199b16";
    };
    kernelModules = ["kvm-intel" "iwlwifi"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.power-profiles-daemon.enable = false;
  programs.auto-cpufreq.enable = true;
  programs.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "auto";
    };

    battery = {
      governor = "powersave";
      turbo = "auto";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@"];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@home"];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@snapshots"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@log"];
    };

    "/var/cache" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@cache"];
    };

    "/etc/nixos" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@nix-config"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = ["defaults" "compress-force=zstd" "noatime" "ssd" "subvol=@nix-store"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/90A5-35FF";
      fsType = "vfat";
    };
  };
  swapDevices = [];
}
