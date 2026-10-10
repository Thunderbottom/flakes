_: {
  profile.disk = {
    rootUUID = "740f7e37-527a-49a1-a6e8-3a81beadf96b";
    luksUUID = "80db9688-8fb5-47c6-a94f-dcb991a80e9a";
    bootUUID = "0BD6-9E8A";
  };

  boot = {
    loader.systemd-boot.configurationLimit = 3;
    initrd = {
      # Override the standard LUKS config with additional options for zippyrus
      luks.devices."cryptroot".crypttabExtraOpts = [
        "no-read-workqueue"
        "no-write-workqueue"
      ];
    };
    kernelParams = [
      "nowatchdog"
      "amdgpu.sg_display=0"
      "transparent_hugepage=madvise"
      "split_lock_detect=off"
    ];
    blacklistedKernelModules = [
      "sp5100_tco"
    ];
  };

  boot.kernel.sysctl."vm.swappiness" = 100;
}
