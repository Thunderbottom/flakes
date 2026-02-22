{
  config,
  lib,

  pkgs,
  userdata,
  ...
}:
{
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/storage" ];
  };

  networking = {
    interfaces.enp2s0 = {
      useDHCP = lib.mkDefault true;
      wakeOnLan.enable = true;
    };
    firewall.allowedTCPPorts = [
      80
      443
    ];
  };

  snowflake = {
    meta.ip.v4 = "192.168.69.193";

    extraPackages = with pkgs; [
      nmap
      recyclarr
    ];

    core.docker.enable = true;
    core.docker.storageDriver = "btrfs";

    hardware.graphics.intel.enable = true;
    hardware.initrd-luks = {
      enable = true;
      authorizedKeys =
        userdata.sshKeys.users.thunderbottom
        ++ [ (builtins.head userdata.sshKeys.machines.thonkpad) ]
        ++ userdata.sshKeys.users.codingcoffee;
      availableKernelModules = [ "r8169" ];
    };

    monitoring = {
      enable = true;
      grafana = {
        domain = "lens.${userdata.domain}";
        adminPasswordFile = userdata.secrets.monitoring.grafana.password;
      };
      victoriametrics.extraPrometheusConfig = [
        {
          job_name = "unpoller";
          static_configs = [
            {
              targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.unpoller.port}" ];
            }
          ];
        }
        {
          job_name = "router";
          static_configs = [
            {
              targets = [ "192.168.69.1:9100" ];
            }
          ];
          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "instance";
              regex = "([^:]+)(:[0-9]+)?";
              replacement = "openwrt";
            }
          ];
        }
      ];
    };

    nginx.wildcard-ssl.sslEnvironmentFile = userdata.secrets.nginx.ssl-environment;

    services = {
      actual = {
        enable = true;
        domain = "actual.${userdata.domain}";
      };

      atuin = {
        enable = true;
        domain = "atuin.${userdata.domain}";
      };

      audiobookshelf = {
        enable = true;
        domain = "books.${userdata.domain}";
      };

      arr.enable = true;
      jellyfin.domain = "jelly.${userdata.domain}";
      jellyseerr.domain = "seerr.${userdata.domain}";

      backups = {
        enable = true;
        repository = "b2:restic-nix";
        resticPasswordFile = userdata.secrets.services.backups.password;
        resticEnvironmentFile = userdata.secrets.services.backups.environment;
      };

      bluesky-pds = {
        enable = true;
        domain = "blue.${userdata.domain}";
        environmentFile = userdata.secrets.services.bluesky-pds.environment;
      };

      duperemove = {
        enable = true;
        extraArgs = "-dr";
        hashfile = "/storage/duperemove.hash";
        paths = [ "/storage/media" ];
      };

      fail2ban = {
        enable = true;
        extraIgnoreIPs = [ "192.168.69.0/16" ];
      };

      forgejo = {
        enable = true;
        domain = "git.${userdata.domain}";
        sshDomain = "git-ssh.${userdata.domain}";
        dbPasswordFile = userdata.secrets.services.forgejo.password;
        actions-runner = {
          enable = true;
          tokenFile = userdata.secrets.services.forgejo.actions-runner.token;
        };
      };

      immich = {
        enable = true;
        domain = "photos.${userdata.domain}";
      };

      miniflux = {
        enable = true;
        domain = "flux.${userdata.domain}";
        adminTokenFile = userdata.secrets.services.miniflux.password;
      };

      nginx = {
        enable = true;
        acmeEmail = userdata.acmeEmail;
        enableCloudflareRealIP = true;
      };

      ntfy-sh = {
        enable = true;
        domain = "ntfy.${userdata.domain}";
      };

      paperless = {
        enable = true;
        domain = "docs.${userdata.domain}";
        passwordFile = userdata.secrets.services.paperless.password;
        adminUser = "chinmay";
      };

      postgresql = {
        enable = true;
        backup.enable = true;
      };

      technitium.enable = true;

      static-sites.sites = {
        maych-in = {
          enable = true;
          package = pkgs.maych-in;
          domain = "maych.in";
        };

        toasters = {
          enable = true;
          package = pkgs.toaste-rs;
          domain = "toaste.rs";
        };
      };

      unifi-controller = {
        enable = true;
        unpoller = {
          enable = true;
          passwordFile = userdata.secrets.services.unifi-unpoller.password;
        };
      };

      # vaultwarden = {
      #   enable = true;
      #   domain = "bw.deku.moe";
      #   adminTokenFile = userdata.secrets.services.vaultwarden.password;
      # };
    };

    user = {
      enable = true;
      username = "server";
      description = "Bicboye Server";
      userPasswordAgeModule = userdata.secrets.machines.bicboye.password;
      rootPasswordAgeModule = userdata.secrets.machines.bicboye.root-password;
      extraAuthorizedKeys =
        userdata.sshKeys.users.thunderbottom
        ++ [ (builtins.head userdata.sshKeys.machines.thonkpad) ]
        ++ userdata.sshKeys.users.codingcoffee;
    };
  };
}
