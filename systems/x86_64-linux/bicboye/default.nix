{
  config,
  lib,
  namespace,
  pkgs,
  userdata,
  ...
}: {
  imports = [./hardware.nix];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "bicboye";
    useDHCP = lib.mkDefault false;
    interfaces.enp2s0 = {
      useDHCP = lib.mkDefault true;
      wakeOnLan.enable = true;
    };
    firewall.allowedTCPPorts = [80 443];
  };

  # Enable weekly btrfs auto-scrub.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  # Power management, enable powertop and thermald.
  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  ${namespace} = {
    stateVersion = "24.05";

    extraPackages = with pkgs; [
      nmap
      recyclarr
    ];

    core.docker.enable = true;
    core.docker.storageDriver = "btrfs";
    core.security.sysctl.enable = lib.mkForce false;

    networking.firewall.enable = true;
    networking.networkManager.enable = true;
    networking.resolved.enable = true;

    hardware.graphics.intel.enable = true;
    hardware.initrd-luks = {
      enable = true;
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyY8ZkhwWiqJCiTqXvHnLpXQb1qWwSZAoqoSWJI1ogP"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C"
      ];
      availableKernelModules = ["r8169"];
    };

    monitoring = {
      enable = true;
      grafana = {
        domain = "lens.deku.moe";
        adminPasswordFile = userdata.secrets.monitoring.grafana.password;
      };
      victoriametrics.extraPrometheusConfig = [
        {
          job_name = "unpoller";
          static_configs = [
            {
              targets = ["127.0.0.1:${toString config.services.prometheus.exporters.unpoller.port}"];
            }
          ];
        }
        {
          job_name = "router";
          static_configs = [
            {
              targets = ["192.168.69.1:9100"];
            }
          ];
          relabel_configs = [
            {
              source_labels = ["__address__"];
              target_label = "instance";
              regex = "([^:]+)(:[0-9]+)?";
              replacement = "openwrt";
            }
          ];
        }
      ];
    };

    services = {
      arr.enable = true;

      backups = {
        enable = true;
        repository = "b2:restic-nix";
        resticPasswordFile = userdata.secrets.services.backups.password;
        resticEnvironmentFile = userdata.secrets.services.backups.environment;
      };

      fail2ban.enable = true;

      forgejo = {
        enable = true;
        domain = "git.deku.moe";
        sshDomain = "git-ssh.deku.moe";
        dbPasswordFile = userdata.secrets.services.forgejo.password;
        actions-runner = {
          enable = true;
          tokenFile = userdata.secrets.services.forgejo.actions-runner.token;
        };
      };

      immich = {
        enable = true;
        domain = "photos.deku.moe";
      };

      miniflux = {
        enable = true;
        domain = "flux.deku.moe";
        adminTokenFile = userdata.secrets.services.miniflux.password;
      };

      nginx = {
        enable = true;
        acmeEmail = "chinmaydpai@gmail.com";
        enableCloudflareRealIP = true;
      };

      ntfy-sh = {
        enable = true;
        domain = "ntfy.deku.moe";
      };

      paperless = {
        enable = true;
        domain = "docs.deku.moe";
        passwordFile = userdata.secrets.services.paperless.password;
        adminUser = "chinmay";
      };

      postgresql = {
        enable = true;
        backup.enable = true;
      };

      technitium.enable = true;

      static-site = {
        enable = true;
        package = pkgs.maych-in;
        domain = "maych.in";
      };

      unifi-controller = {
        enable = true;
        unpoller = {
          enable = true;
          passwordFile = userdata.secrets.services.unifi-unpoller.password;
        };
      };

      vaultwarden = {
        enable = true;
        domain = "bw.deku.moe";
        adminTokenFile = userdata.secrets.services.vaultwarden.password;
      };
    };

    user = {
      enable = true;
      username = "server";
      description = "Bicboye Server";
      userPasswordAgeModule = userdata.secrets.machines.bicboye.password;
      rootPasswordAgeModule = userdata.secrets.machines.bicboye.root-password;
      extraAuthorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyY8ZkhwWiqJCiTqXvHnLpXQb1qWwSZAoqoSWJI1ogP"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C"
      ];
    };
  };
}
