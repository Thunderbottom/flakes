{
  lib,

  userdata,
  ...
}:
let
  hostname = "server";
in
{
  imports = [ ./disk-config.nix ];

  # NOTE: since we use disko to configure disks, the boot configuration
  # needs to be updated here. If you do not wish to use disko, you can move
  # this section to hardware.nix.
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "ehci_pci"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    initrd.supportedFilesystems = [ ];
    kernelModules = [ ];
    kernelParams = [ "console=tty" ];
    loader.grub = {
      device = "/dev/sda";
      configurationLimit = 2;
    };
  };

  # Enable microcode updates for the CPU
  # NOTE: Only enable the one that is required.
  # hardware.cpu.amd.updateMicrocode = true;
  # hardware.cpu.intel.updateMicrocode = true;

  # Enable redistributable firmware for non-free hardware
  hardware.enableRedistributableFirmware = true;

  # Networking configuration
  networking = {
    hostName = hostname;
    nameservers = [ "1.1.1.1" ];
    useDHCP = lib.mkDefault false;
    interfaces.enp1s0 = {
      useDHCP = lib.mkDefault true;
      ipv6.addresses = [
        {
          address = "2a69:4f9:1c1d:91b::";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  # TODO: replace email with an actual email for letsencrypt
  security.acme.defaults.email = "server@mail.com";

  snowflake = {
    stateVersion = "24.11";
    bootloader = "grub";

    core.security.sysctl.enable = lib.mkForce false;

    networking.firewall.enable = true;
    networking.networkManager.enable = true;
    networking.resolved.enable = true;

    services.fail2ban.enable = true;

    user = {
      enable = true;
      username = "server";
      description = "Server";
      userPasswordAgeModule = userdata.secrets.machines.${hostname}.password;
      rootPasswordAgeModule = userdata.secrets.machines.${hostname}.root-password;
      extraAuthorizedKeys = [ ];
    };
  };
}
