_: {
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "xhci_hcd"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      luks.devices."cryptroot".device = "/dev/disk/by-uuid/312b4d84-64dc-4721-9be3-bb0148199b16";
      luks.devices."cryptroot".preLVM = true;
    };
    kernelModules = [
      "kvm-intel"
      "thinkpad_acpi"
      "iwlwifi"
      "i915"
    ];
    blacklistedKernelModules = [
      "iTCO_wdt"
    ];
    kernelParams = ["resume_offset=2465529" "intel_pstate=active" "i915.enable_gvt=1" "i915.enable_guc=3" "thinkpad_acpi.fan_control=1"];
    resumeDevice = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
    supportedFilesystems = ["btrfs"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = [
        "defaults"
        # "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@"
        "discard=async"
      ];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = [
        "defaults"
        # "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@home"
        "discard=async"
      ];
    };

    "/.snapshots" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@snapshots"
        "discard=async"
      ];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = [
        "defaults"
        # "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@log"
        "discard=async"
      ];
    };

    "/var/cache" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = [
        "defaults"
        # "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@cache"
        "discard=async"
      ];
    };

    "/etc/nixos" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
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
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = [
        "defaults"
        # "autodefrag"
        "compress-force=zstd"
        "noatime"
        "ssd"
        "subvol=@nix-store"
        "discard=async"
      ];
    };

    # ref: https://sawyershepherd.org/post/hibernating-to-an-encrypted-swapfile-on-btrfs-with-nixos/
    "/swap" = {
      device = "/dev/disk/by-uuid/d5c21883-f0e6-4e7a-b9a5-ee0bf4780ec5";
      fsType = "btrfs";
      options = [
        "subvol=@swap"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/90A5-35FF";
      fsType = "vfat";
    };
  };
  swapDevices = [{device = "/swap/swapfile";}];
}
