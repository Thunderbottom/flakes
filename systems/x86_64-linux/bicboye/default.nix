{
  lib,
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
    interfaces.enp6s0 = {
      useDHCP = lib.mkDefault true;
      wakeOnLan.enable = true;
    };
    firewall.allowedTCPPorts = [
      80
      443
    ];
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

  # TODO: move to module
  security.acme.defaults.email = "chinmaydpai@gmail.com";
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;
  };

  snowflake = {
    stateVersion = "24.05";

    core.docker.enable = true;
    core.docker.storageDriver = "btrfs";
    core.security.sysctl.enable = lib.mkForce false;

    networking.networkManager.enable = true;

    hardware.initrd-luks = {
      enable = true;
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyY8ZkhwWiqJCiTqXvHnLpXQb1qWwSZAoqoSWJI1ogP"
      ];
      availableKernelModules = ["r8169"];
    };

    services = {
      gitea = {
        enable = true;
        domain = "git.deku.moe";
        sshDomain = "git-ssh.deku.moe";
        dbPasswordFile = userdata.secrets.services.gitea.password;
      };

      miniflux = {
        enable = true;
        domain = "flux.deku.moe";
        adminTokenFile = userdata.secrets.services.miniflux.password;
      };

      paperless = {
        enable = true;
        domain = "docs.deku.moe";
        passwordFile = userdata.secrets.services.paperless.password;
        adminUser = "chinmay";
      };

      vaultwarden = {
        enable = true;
        domain = "bw.deku.moe";
        adminTokenFile = userdata.secrets.services.vaultwarden.password;
      };

      static-site = {
        enable = true;
        package = pkgs.maych-in;
        domain = "maych.in";
      };
      unifi-controller.enable = true;
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
      ];
    };
  };
}
