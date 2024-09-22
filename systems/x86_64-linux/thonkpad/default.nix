{
  lib,
  pkgs,
  userdata,
  ...
}: {
  imports = [./hardware.nix];

  chaotic.mesa-git.enable = true;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa_git.opencl
  ];

  networking.hostName = "thonkpad";
  networking.interfaces.wlan0.useDHCP = lib.mkDefault false;
  networking.useNetworkd = true;

  # Enable weekly btrfs auto-scrub.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  services.system76-scheduler.enable = true;
  services.system76-scheduler.settings.cfsProfiles.enable = true;
  # Power management, enable powertop and thermald.
  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  services.thermald.enable = true;

  # TODO: remove, temporary for mongoDB build
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp/nix-daemon";

  services.ratbagd.enable = true;

  snowflake = {
    stateVersion = "24.05";
    extraPackages = with pkgs; [
      easyeffects
      glibc
      obsidian
      piper
      # terraform
      terraform-ls
    ];

    core.lanzaboote.enable = true;

    core.docker.enable = true;
    core.docker.storageDriver = "btrfs";

    desktop.enable = true;
    desktop.fingerprint.enable = true;
    desktop.kde.enable = true;

    gaming.steam.enable = true;

    hardware.bluetooth.enable = true;
    hardware.yubico.enable = true;

    networking.firewall.enable = true;
    networking.networkManager.enable = true;
    networking.iwd.enable = true;
    networking.resolved.enable = true;
    networking.netbird.enable = true;

    user.enable = true;
    user.username = "chnmy";
    user.description = "Chinmay D. Pai";
    user.extraGroups = ["video"];
    user.userPasswordAgeModule = userdata.secrets.machines.thonkpad.password;
    user.rootPasswordAgeModule = userdata.secrets.machines.thonkpad.root-password;
  };
}
