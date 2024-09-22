{
  lib,
  pkgs,
  ...
}: {
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
      luks.devices."cryptroot".bypassWorkqueues = true;
    };
    kernelModules = [
      "kvm-intel"
      "iwlwifi"
      "xe"
    ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_testing;
    kernelParams = [
      # NixOS produces many wakeups per second, which is bad for battery life.
      # This disables the timer tick on the last 7 cores.
      "nohz_full=14-21"
      "i915.force_probe=!7d55"
      "xe.force_probe=7d55"
      # "resume_offset=2465529"
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

    # TODO: setup swap
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
      device = "/dev/disk/by-uuid/7FBB-9E80";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };
  swapDevices = [];
}
