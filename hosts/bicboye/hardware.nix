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
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:3" # Level 3 for better performance/compression balance
        "noatime" # Don't update access times for better performance
        "nodiratime" # Don't update directory access times
        "ssd" # SSD optimizations
        "space_cache=v2" # Faster free space cache
        "commit=120" # Commit interval for better write performance
        "discard=async" # Async discard for better SSD performance
        "subvol=@"
      ];
      neededForBoot = true; # required
    };

    "/home" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:3"
        "noatime"
        "nodiratime"
        "ssd"
        "space_cache=v2"
        "commit=120"
        "discard=async"
        "subvol=@home"
      ];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:3"
        "noatime"
        "nodiratime"
        "ssd"
        "space_cache=v2"
        "commit=120"
        "discard=async"
        "subvol=@snapshots"
      ];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:3"
        "noatime"
        "nodiratime"
        "ssd"
        "space_cache=v2"
        "commit=120"
        "discard=async"
        "subvol=@log"
      ];
    };

    "/etc/nixos" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:3"
        "noatime"
        "nodiratime"
        "ssd"
        "space_cache=v2"
        "commit=120"
        "discard=async"
        "subvol=@nixos-config"
      ];
    };

    "/var/cache" = {
      device = "/dev/disk/by-uuid/a1b57a56-16d4-45ea-bac3-daeacd3dbcb2";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:3"
        "noatime"
        "nodiratime"
        "ssd"
        "space_cache=v2"
        "commit=120"
        "discard=async"
        "subvol=@cache"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/B731-09A3";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/storage/media" = {
      device = "/dev/disk/by-uuid/8cf1e73e-39fe-4e5d-a2ec-652e51931f27";
      fsType = "btrfs";
      options = [
        "compress-force=zstd:3" # Level 3 for good compression on media storage
        "noatime" # Don't update access times
        "nodiratime" # Don't update directory access times
        "space_cache=v2" # Faster free space cache
        "commit=120" # Longer commit interval for large files
        "autodefrag" # Auto-defrag for media files
        "user"
      ];
    };
  };
  swapDevices = [ ];
}
