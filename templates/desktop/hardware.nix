{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    initrd = {
      availableKernelModules = [
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
    kernelModules = [ ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [ ];
    blacklistedKernelModules = [ ];
    extraModulePackages = with config.boot.kernelPackages; [ ];

    # In case hibernate support is required, create a `filesystems."/swap"` entry
    # and enable the following option.
    # resumeDevice = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
  };

  # Filesystem configuration.
  # NOTE: This will require changes based on
  # the system's partition table and filesystem type.
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/da17b8ca-aefe-4b97-b493-694db0fa0972";
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
      device = "/dev/disk/by-uuid/da17b8ca-aefe-4b97-b493-694db0fa0972";
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
      device = "/dev/disk/by-uuid/da17b8ca-aefe-4b97-b493-694db0fa0972";
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
      device = "/dev/disk/by-uuid/da17b8ca-aefe-4b97-b493-694db0fa0972";
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
      device = "/dev/disk/by-uuid/da17b8ca-aefe-4b97-b493-694db0fa0972";
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
      device = "/dev/disk/by-uuid/da17b8ca-aefe-4b97-b493-694db0fa0972";
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
      device = "/dev/disk/by-uuid/da17b8ca-aefe-4b97-b493-694db0fa0972";
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
    #   device = "/dev/disk/by-uuid/da17b8ca-aefe-4b97-b493-694db0fa0972";
    #   fsType = "btrfs";
    #   options = [
    #     "subvol=@swap"
    #     "noatime"
    #   ];
    # };

    "/boot" = {
      device = "/dev/disk/by-uuid/0BD6-9E8A";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  swapDevices = [ ];
}
