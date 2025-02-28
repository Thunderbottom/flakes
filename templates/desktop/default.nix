{
  lib,
  namespace,
  pkgs,
  userdata,
  ...
}: let
  # TODO: Update the hostname
  hostname = "desktop";
in {
  imports = [./hardware.nix];

  # Enable microcode updates for the CPU
  # NOTE: Only enable the one that is required.
  # hardware.cpu.amd.updateMicrocode = true;
  # hardware.cpu.intel.updateMicrocode = true;

  # Enable redistributable firmware for non-free hardware
  hardware.enableRedistributableFirmware = true;

  # Configure networking for the system
  networking.hostName = hostname;
  networking.interfaces.wlan0.useDHCP = lib.mkDefault false;
  networking.useNetworkd = true;

  # Power management, enable powertop and thermald.
  powerManagement.powertop.enable = true;

  # Enable thermald for laptops
  # services.thermald.enable = true;

  services.xserver.videoDrivers = lib.mkForce ["amdgpu" "nvidia"];

  ${namespace} = {
    # NOTE: Since the system runs on nixos-unstable, this should be
    # set to the latest version as of the installation time. Can also
    # be left as-is.
    stateVersion = "25.05";

    # Add extra packages to the system
    extraPackages = [];

    # Enable secure boot support.
    # NOTE: Requires setting up lanzaboote, read the link below for help.
    # ref: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
    # core.lanzaboote.enable = true;

    # Enable docker service
    core.docker.enable = true;
    # NOTE: enable in case the filesystem in use is
    # anything other than ext4.
    # core.docker.storageDriver = "btrfs";

    # Enable desktop environment, and configure GNOME.
    desktop.enable = true;
    desktop.gnome.enable = true;

    # Enable steam and proton libraries
    gaming.proton.enable = true;
    gaming.steam.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;

    # Enable Yubikey support
    hardware.yubico.enable = true;

    # Enable GPU support.
    # NOTE: you will be required to set up the bus IDs
    # if the system has an Nvidia GPU.
    hardware.graphics = {
      amd.enable = true;
      nvidia = {
        enable = true;
        busIDs = {
          amd = "PCI:101:0:0";
          nvidia = "PCI:1:0:0";
        };
      };
    };

    # Enable firewall and NetworkManager
    networking.firewall.enable = true;
    networking.networkManager.enable = true;

    # Switch the NetworkManager backend to iwd.
    # NOTE: this is suggested and will only work if the system
    # has an intel network card.
    # networking.iwd.enable = true;

    # Enable systemd-resolved service
    networking.resolved.enable = true;

    # User configuration.
    # TODO: change the username and the description for the user.
    user.enable = true;
    user.username = "user";
    user.description = "User McUserface";
    user.extraGroups = ["video"];
    # NOTE: The following module needs an entry in secrets.nix and data.nix
    # The secrets are configured using agenix. Check out the readme for more information.
    user.userPasswordAgeModule = userdata.secrets.machines.${hostname}.password;
    user.rootPasswordAgeModule = userdata.secrets.machines.${hostname}.root-password;
  };
}
