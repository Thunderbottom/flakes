{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Use standard btrfs layout module
  snowflake.hardware.btrfs-standard-layout = {
    enable = true;
    rootUUID = "740f7e37-527a-49a1-a6e8-3a81beadf96b";
    luksUUID = "80db9688-8fb5-47c6-a94f-dcb991a80e9a";
    bootUUID = "0BD6-9E8A";
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "mt7921e"
        "nvme"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "xhci_pci"
      ];
      # Override the standard LUKS config with additional options for zippyrus
      luks.devices."cryptroot".crypttabExtraOpts = [
        "no-read-workqueue"
        "no-write-workqueue"
      ];
    };
    kernelModules = [
      "kvm-amd"
      "zenpower"
    ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [
      "nowatchdog"
      "amd_pstate=active"
      "amdgpu.sg_display=0"
      "amdgpu.dcdebugmask=0x10"
      "pcie_aspm.policy=powersupersave"
      # Attempt to fix mediatek wifi lag/latency on MT7922
      "mt7921e.disable_aspm=Y"
      "transparent_hugepage=madvise"
      "split_lock_detect=off"
    ];
    blacklistedKernelModules = [
      "k10temp"
      "sp5100_tco"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
    # resumeDevice = "/dev/disk/by-uuid/740f7e37-527a-49a1-a6e8-3a81beadf96b";
  };
}
