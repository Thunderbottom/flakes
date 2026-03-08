{
  lib,
  pkgs,
  ...
}:
{
  # Use standard btrfs layout module
  snowflake.hardware.btrfs-standard-layout = {
    enable = true;
    rootUUID = "870fde90-a91a-4554-8b1c-d5702c789f4d";
    luksUUID = "9de352ea-128f-4d56-a720-36d81dfd9b92";
    bootUUID = "7FBB-9E80";
  };

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
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
}
