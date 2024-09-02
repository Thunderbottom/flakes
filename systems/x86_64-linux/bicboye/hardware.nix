_: {
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "ehci_pci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      luks.devices."cryptroot".device = "/dev/disk/by-uuid/e570c2be-65df-4208-9cac-a03de08a6209";
    };
    kernelModules = ["kvm-intel"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@"
      ];
      neededForBoot = true; # required
    };

    "/home" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@home"
      ];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
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
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@log"
      ];
    };

    "/etc/nixos" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@nixos-config"
      ];
    };

    "/var/cache" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@cache"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/B731-09A3";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/storage/media" = {
      device = "/dev/disk/by-uuid/f8aadf58-d561-476b-a2c5-64b266dc5755";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "user"
      ];
    };
  };
  swapDevices = [];
}
