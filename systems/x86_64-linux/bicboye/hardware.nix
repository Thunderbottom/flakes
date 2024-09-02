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
      luks.devices."root".device = "/dev/disk/by-uuid/e70bfc3c-1147-4af7-9bae-69f70146953f";
    };
    kernelModules = ["kvm-intel"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
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
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
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
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
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
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
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
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
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
      device = "/dev/disk/by-uuid/5cabc339-898c-4604-9bfc-0a2cf17e44ca";
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
      device = "/dev/disk/by-uuid/1C6C-122C";
      fsType = "vfat";
    };

    "/storage/immich" = {
      device = "/dev/disk/by-uuid/bae65b7a-4f08-4b0d-963c-72e71bfcff46";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress-force=zstd"
        "noatime"
        "user"
      ];
    };

    # TODO: delete btrfs subvolume
    "/storage/syncthing" = {
      device = "/dev/disk/by-uuid/e3a4c251-a3e2-4b5e-a63b-70f53b51836a";
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
