{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "mt7921e"
        "nvme"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "xhci_pci"
      ];
      luks.devices."cryptroot".device = "/dev/disk/by-uuid/80db9688-8fb5-47c6-a94f-dcb991a80e9a";
      luks.devices."cryptroot".bypassWorkqueues = true;
    };
    kernelModules = ["acpi_call" "kvm-amd" "zenpower"];
    kernelPackages = lib.mkForce pkgs.linuxPackages_testing;
    kernelParams = ["nowatchdog" "amd_pstate=active" "mem_sleep_default=deep" "pcie_aspm.policy=powersupersave"];
    blacklistedKernelModules = ["k10temp" "sp5100_tco"];
    extraModulePackages = with config.boot.kernelPackages; [zenpower acpi_call];
    # resumeDevice = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
      fsType = "btrfs";
      options = [
        "defaults"
        "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@"
      ];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
      fsType = "btrfs";
      options = [
        "defaults"
        "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@home"
      ];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@snapshots"
      ];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
      fsType = "btrfs";
      options = [
        "defaults"
        "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@log"
      ];
    };

    "/var/cache" = {
      device = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
      fsType = "btrfs";
      options = [
        "defaults"
        "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@cache"
      ];
    };

    "/etc/nixos" = {
      device = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@nix-config"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
      fsType = "btrfs";
      options = [
        "defaults"
        "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@nix-store"
      ];
    };

    # TODO: setup swap
    # ref: https://sawyershepherd.org/post/hibernating-to-an-encrypted-swapfile-on-btrfs-with-nixos/
    # "/swap" = {
    #   device = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
    #   fsType = "btrfs";
    #   options = [
    #     "subvol=@swap"
    #     "noatime"
    #   ];
    # };

    "/boot" = {
      device = "/dev/disk/by-uuid/0BD6-9E8A";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };
  swapDevices = [];
}
