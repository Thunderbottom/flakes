_: {
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      luks.devices."cryptroot".device = "/dev/disk/by-uuid/9de352ea-128f-4d56-a720-36d81dfd9b92";
    };
    kernelModules = [
      "kvm-intel"
      # "thinkpad_acpi"
      "iwlwifi"
      "xe"
    ];
    kernelParams = [
      "xe.force_probe=7d45"
      # "resume_offset=2465529"
      # "intel_pstate=active"
      # "thinkpad_acpi.fan_control=1"
    ];
    # resumeDevice = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
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
      device = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
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
      device = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
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
      device = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
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
      device = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
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
      device = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
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
      device = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
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

    # ref: https://sawyershepherd.org/post/hibernating-to-an-encrypted-swapfile-on-btrfs-with-nixos/
    # "/swap" = {
    #   device = "/dev/disk/by-uuid/870fde90-a91a-4554-8b1c-d5702c789f4d";
    #   fsType = "btrfs";
    #   options = [
    #     "subvol=@swap"
    #     "noatime"
    #   ];
    # };

    "/boot" = {
      device = "/dev/disk/by-uuid/B9A2-7AA6";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };
  swapDevices = [];
}