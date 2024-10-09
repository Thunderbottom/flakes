{
  lib,
  pkgs,
  userdata,
  ...
}: {
  imports = [./hardware.nix];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "thonkpad";
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
