{
  lib,
  pkgs,
  ...
}:
{
  # Use standard btrfs layout module
  snowflake.hardware.btrfs-standard-layout = {
    enable = true;
    rootUUID = "7293d745-b036-45b5-8de1-67df46be0d44";
    luksUUID = "e2ae9b2d-3c83-40ea-ac52-b45142bb1c16";
    bootUUID = "2CA8-D5C1";
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
    # resumeDevice = "/dev/disk/by-uuid/7293d745-b036-45b5-8de1-67df46be0d44";
  };
}
