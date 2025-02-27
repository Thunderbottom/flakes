{
  config,
  lib,
  namespace,
  userdata,
  ...
}: {
  imports = [./disk-config.nix];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "ehci_pci" "nvme" "usb_storage" "sd_mod"];
    initrd.supportedFilesystems = ["btrfs"];
    kernelModules = ["kvm-intel" "virtio_gpu"];
    kernelParams = ["console=tty"];
    loader.grub = {
      device = "/dev/sda";
      configurationLimit = 2;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "smolboye";
    nameservers = ["1.1.1.1"];
    useDHCP = lib.mkDefault false;
    interfaces.enp1s0 = {
      useDHCP = lib.mkDefault true;
      ipv6.addresses = [
        {
          address = "2a01:4f8:1c1c:90b::";
          prefixLength = 64;
        }
      ];
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
    firewall.allowedTCPPorts = [80 443];
  };

  # Enable weekly btrfs auto-scrub.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  security.acme.defaults.email = "chinmaydpai@gmail.com";

  age.secrets = {
    mailserver-watashi.file = userdata.secrets.services.mailserver.watashi.password.file;
    mailserver-noreply.file = userdata.secrets.services.mailserver.noreply.password.file;
  };

  ${namespace} = {
    stateVersion = "24.11";
    bootloader = "grub";

    core.security.sysctl.enable = lib.mkForce false;

    networking.firewall.enable = true;
    networking.networkManager.enable = true;
    networking.resolved.enable = true;

    services = {
      fail2ban.enable = true;

      mailserver = {
        enable = true;
        fqdn = "mail.deku.moe";
        domains = ["deku.moe"];
        loginAccounts = {
          "watashi@deku.moe" = {
            hashedPasswordFile = config.age.secrets.mailserver-watashi.path;
            aliases = ["@deku.moe"];
            catchAll = ["deku.moe"];
          };
          "noreply@deku.moe" = {
            hashedPasswordFile = config.age.secrets.mailserver-noreply.path;
            aliases = ["git@deku.moe" "jelly@deku.moe" "vaultwarden@deku.moe"];
            sendOnly = true;
          };
        };
      };
    };

    user = {
      enable = true;
      username = "server";
      description = "Smolboye Server";
      userPasswordAgeModule = userdata.secrets.machines.smolboye.password;
      rootPasswordAgeModule = userdata.secrets.machines.smolboye.root-password;
      extraAuthorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyY8ZkhwWiqJCiTqXvHnLpXQb1qWwSZAoqoSWJI1ogP"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C"
      ];
    };
  };
}
