{
  lib,
  pkgs,
  ...
}:
{
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
    ];

    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [
      # NixOS produces many wakeups per second, which is bad for battery life.
      # This disables the timer tick on the last 7 cores.
      "nohz_full=14-21"
      # Enable Intel Xe driver (experimental)
      # NOTE: rendering on latest firefox (> 130) seems to be broken.
      # "i915.force_probe=!7d55"
      # "xe.force_probe=7d55"

      # Potentially improve performance on intel CPUs
      "dev.i915.perf_stream_paranoid=0"

      # This solves an issue with resume after suspend where the SSD goes into
      # a read-only state. We trust some random, obscure Arch wiki article over
      # actually trying to figure out why it might be so.
      # ref: https://wiki.archlinux.org/title/Solid_state_drive/NVMe#Controller_failure_due_to_broken_suspend_support
      # "iommu=soft"

      # Setup encrypted swap
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
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  swapDevices = [ ];
}
