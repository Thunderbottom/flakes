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

    user.enable = true;
    user.username = "chnmy";
    user.description = "Chinmay D. Pai";
    user.extraGroups = [ "video" ];
    user.userPasswordAgeModule = userdata.secrets.machines.thonkpad.password;
    user.rootPasswordAgeModule = userdata.secrets.machines.thonkpad.root-password;
  };
}
