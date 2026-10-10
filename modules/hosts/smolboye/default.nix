{ nixos, ... }:
{
  configurations.nixos.smolboye.module =
    {
      config,
      inputs,
      lib,

      ...
    }:
    {
      imports = [
        nixos.server
        nixos.mailserver
        nixos.vaultwarden
        ./_disk-config.nix
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.srvos.nixosModules.hardware-hetzner-cloud
      ];

      boot = {
        initrd.systemd.enable = false;
        initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "ehci_pci"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
        initrd.supportedFilesystems = [ "btrfs" ];
        kernelModules = [
          "kvm-intel"
          "virtio_gpu"
        ];
        kernelParams = [ "console=tty" ];
        loader = {
          efi.canTouchEfiVariables = lib.mkForce false;
          systemd-boot.enable = false;
          grub = {
            enable = true;
            device = lib.mkForce "nodev";
            efiInstallAsRemovable = true;
            configurationLimit = 2;
          };
        };
      };

      networking = {
        nameservers = [ "1.1.1.1" ];
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
      };

      # Disable smartd, not required for VPS
      services.smartd.enable = lib.mkForce false;

      profile.fullName = "Smolboye Server";
      home-manager.users.${config.profile.username}.home.stateVersion = "24.11";

      age.secrets = {
        mailserver-watashi.file = config.profile.secrets.services.mailserver.watashi.file;
        mailserver-noreply.file = config.profile.secrets.services.mailserver.noreply.file;
      };

      services.postfix.settings.main.smtp_bind_address6 = "2a01:4f8:1c1c:90b::";

      mailserver = {
        fqdn = "mail.${config.profile.domain}";
        domains = [ config.profile.domain ];
        accounts = {
          "watashi@${config.profile.domain}" = {
            hashedPasswordFile = config.age.secrets.mailserver-watashi.path;
            aliases = [ "@${config.profile.domain}" ];
            catchAll = [ config.profile.domain ];
          };
          "noreply@${config.profile.domain}" = {
            hashedPasswordFile = config.age.secrets.mailserver-noreply.path;
            aliases = [
              "git@${config.profile.domain}"
              "jelly@${config.profile.domain}"
              "vaultwarden@${config.profile.domain}"
            ];
            sendOnly = true;
          };
        };
      };
    };
}
