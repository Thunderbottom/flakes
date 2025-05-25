_: {
  boot = {
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/384c8c88-f6a1-493e-af60-3cc5ad2300f0";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "subvol=/root"
      ];
      neededForBoot = true; # required
    };

    "/home" = {
      device = "/dev/disk/by-uuid/384c8c88-f6a1-493e-af60-3cc5ad2300f0";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "subvol=/home"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/384c8c88-f6a1-493e-af60-3cc5ad2300f0";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "subvol=/nix"
      ];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/384c8c88-f6a1-493e-af60-3cc5ad2300f0";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "subvol=/log"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/D1FC-5DEA";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  swapDevices = [ ];
}
