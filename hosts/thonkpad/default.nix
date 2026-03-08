{
  inputs,
  pkgs,
  userdata,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
  ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  snowflake = {
    # Enable laptop profile (includes power management, NetworkManager, user defaults)
    profile.laptop.enable = true;
    extraPackages = with pkgs; [
      easyeffects
      glibc
      logseq
      obsidian
    ];

    core.lanzaboote.enable = true;
    core.docker.enable = true;
    core.docker.storageDriver = "btrfs";

    desktop.enable = true;
    desktop.fingerprint.enable = true;
    desktop.gnome.enable = true;

    gaming.steam.enable = true;

    hardware.bluetooth.enable = true;
    hardware.yubico.enable = true;
    hardware.graphics.intel = {
      enable = true;
    };

    networking.iwd.enable = true;
    networking.netbird.enable = true;

    # Host-specific password configuration (other user settings from laptop profile)
    user.userPasswordAgeModule = userdata.secrets.machines.thonkpad.password;
    user.rootPasswordAgeModule = userdata.secrets.machines.thonkpad.root-password;
  };
}
