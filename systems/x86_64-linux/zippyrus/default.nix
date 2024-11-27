{
  lib,
  pkgs,
  userdata,
  ...
}: {
  imports = [./hardware.nix];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.sensor.iio.enable = true;

  networking.hostName = "zippyrus";
  networking.interfaces.wlan0.useDHCP = lib.mkDefault false;
  networking.useNetworkd = true;

  # Enable weekly btrfs auto-scrub.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  # Power management, enable powertop and thermald.
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  services.ratbagd.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  snowflake = {
    stateVersion = "24.05";
    extraPackages = with pkgs; [
      obsidian
      piper
    ];

    core.lanzaboote.enable = true;
    core.docker.enable = true;
    core.docker.storageDriver = "btrfs";

    desktop.enable = true;
    desktop.kde.enable = true;

    gaming.proton.enable = true;
    gaming.steam.enable = true;

    hardware.bluetooth.enable = true;
    hardware.yubico.enable = true;
    hardware.graphics = {
      amd.enable = true;
      nvidia.enable = true;
    };

    networking.firewall.enable = true;
    networking.networkManager.enable = true;
    networking.iwd.enable = true;
    networking.resolved.enable = true;

    services.asus.enable = true;

    user.enable = true;
    user.username = "chnmy";
    user.description = "Chinmay D. Pai";
    user.extraGroups = ["video"];
    user.userPasswordAgeModule = userdata.secrets.machines.zippyrus.password;
    user.rootPasswordAgeModule = userdata.secrets.machines.zippyrus.root-password;
  };
}
