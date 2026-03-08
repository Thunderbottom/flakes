{
  inputs,
  pkgs,
  userdata,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
  ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  snowflake = {
    # Enable laptop profile (includes power management, NetworkManager, btrfs scrub, user defaults)
    profile.laptop.enable = true;

    # core.lanzaboote.enable = true;
    core.docker.enable = true;
    core.docker.storageDriver = "btrfs";

    desktop.enable = true;
    desktop.fingerprint.enable = true;
    desktop.gnome.enable = true;

    gaming.steam.enable = true;

    hardware.bluetooth.enable = true;
    hardware.graphics.intel = {
      enable = true;
      computeRuntime = pkgs.intel-compute-runtime-legacy1;
    };

    networking.iwd.enable = true;

    # Host-specific password configuration (other user settings from laptop profile)
    user.userPasswordAgeModule = userdata.secrets.machines.donkpad.password;
    user.rootPasswordAgeModule = userdata.secrets.machines.donkpad.root-password;
  };
}
