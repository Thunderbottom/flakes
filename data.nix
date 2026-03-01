{
  acmeEmail = "chinmaydpai@gmail.com";

  domain = "deku.moe";

  sshKeys = {
    users = {
      thunderbottom = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM"
      ];
      codingcoffee = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN cc@predator"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C cc@eden"
      ];
    };
    machines = {
      donkpad = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiN+hb+hpLksNnj9mov29PNcfBdTCM8I+62+ycUAofx"
      ];
      thonkpad = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyY8ZkhwWiqJCiTqXvHnLpXQb1qWwSZAoqoSWJI1ogP"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrNdHskpknCow+nuCTEBRrKb0b2BKzwTQY60eEAWztS"
      ];
      zippyrus = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLWaHgjXm/P8YBoGPeN6UKgl+2o2YoyoKELNYP1pbVy"
      ];
      smolboye = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQFm91hLes24sYbq96zD52mDrrr1l2F2xstcfAEg+qI"
      ];
      bicboye = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsciEMPwLAYtbHNkdedjhSrb66fFQ46lgnVGssCuiLH"
      ];
    };
  };

  secrets = {
    machines = {
      donkpad = {
        password.file = ./secrets/machines/donkpad/password.age;
        root-password.file = ./secrets/machines/donkpad/root-password.age;
      };
      thonkpad = {
        password.file = ./secrets/machines/thonkpad/password.age;
        root-password.file = ./secrets/machines/thonkpad/root-password.age;
      };
      zippyrus = {
        password.file = ./secrets/machines/zippyrus/password.age;
        root-password.file = ./secrets/machines/zippyrus/root-password.age;
      };
      bicboye = {
        password.file = ./secrets/machines/bicboye/password.age;
        root-password.file = ./secrets/machines/bicboye/root-password.age;
      };
      smolboye = {
        password.file = ./secrets/machines/smolboye/password.age;
        root-password.file = ./secrets/machines/smolboye/root-password.age;
      };
    };
    monitoring = {
      grafana = {
        password.file = ./secrets/monitoring/grafana/password.age;
      };
    };
    network-manager.passphrase.file = ./secrets/network-manager/passphrase.age;
    nginx.ssl-environment.file = ./secrets/services/bluesky-pds/ssl-environment.age;
    services = {
      backups = {
        environment.file = ./secrets/services/backups/environment.age;
        password.file = ./secrets/services/backups/password.age;
      };
      bluesky-pds = {
        environment.file = ./secrets/services/bluesky-pds/environment.age;
      };
      cloudflare-ddns = {
        api-token.file = ./secrets/services/cloudflare-ddns/api.age;
      };
      forgejo = {
        password.file = ./secrets/services/forgejo/password.age;
        actions-runner.token.file = ./secrets/services/forgejo/actions-runner/token.age;
      };
      mailserver = {
        watashi.password.file = ./secrets/services/mailserver/watashi.age;
        noreply.password.file = ./secrets/services/mailserver/noreply.age;
      };
      miniflux = {
        password.file = ./secrets/services/miniflux/password.age;
      };
      paperless = {
        password.file = ./secrets/services/paperless/password.age;
      };
      unifi-unpoller = {
        password.file = ./secrets/services/unifi-unpoller/password.age;
      };
      vaultwarden = {
        password.file = ./secrets/services/vaultwarden/password.age;
      };
    };
  };
}
