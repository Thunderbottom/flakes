let
  codingcoffee = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN cc@predator"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C cc@eden"
  ];
  thunderbottom = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM"
  ];

  thonkpad = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyY8ZkhwWiqJCiTqXvHnLpXQb1qWwSZAoqoSWJI1ogP"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrNdHskpknCow+nuCTEBRrKb0b2BKzwTQY60eEAWztS"
  ];
  zippyrus = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLWaHgjXm/P8YBoGPeN6UKgl+2o2YoyoKELNYP1pbVy"
  ];

  smolboye = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQFm91hLes24sYbq96zD52mDrrr1l2F2xstcfAEg+qI" ];
  bicboye = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsciEMPwLAYtbHNkdedjhSrb66fFQ46lgnVGssCuiLH"
  ];

  servers = bicboye ++ smolboye;
  users = thunderbottom ++ codingcoffee;
in
{
  "machines/thonkpad/password.age".publicKeys = thunderbottom ++ thonkpad;
  "machines/thonkpad/root-password.age".publicKeys = thunderbottom ++ thonkpad;
  "machines/zippyrus/password.age".publicKeys = thunderbottom ++ zippyrus;
  "machines/zippyrus/root-password.age".publicKeys = thunderbottom ++ zippyrus;
  "machines/bicboye/password.age".publicKeys = thunderbottom ++ bicboye;
  "machines/bicboye/root-password.age".publicKeys = thunderbottom ++ bicboye;
  "machines/smolboye/password.age".publicKeys = thunderbottom ++ smolboye;
  "machines/smolboye/root-password.age".publicKeys = thunderbottom ++ smolboye;
  "monitoring/grafana/password.age".publicKeys = thunderbottom ++ bicboye;
  "network-manager/passphrase.age".publicKeys = thunderbottom ++ zippyrus;
  "services/backups/environment.age".publicKeys = thunderbottom ++ bicboye;
  "services/backups/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/bluesky-pds/environment.age".publicKeys = thunderbottom ++ bicboye;
  "services/bluesky-pds/ssl-environment.age".publicKeys = thunderbottom ++ bicboye;
  "services/forgejo/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/forgejo/actions-runner/token.age".publicKeys = thunderbottom ++ bicboye;
  "services/maddy/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/maddy/user-watashi.age".publicKeys = thunderbottom ++ servers;
  "services/mailserver/watashi.age".publicKeys = thunderbottom ++ smolboye;
  "services/mailserver/noreply.age".publicKeys = thunderbottom ++ smolboye;
  "services/miniflux/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/paperless/password.age".publicKeys = users ++ bicboye;
  "services/unifi-unpoller/password.age".publicKeys = users ++ bicboye;
  "services/vaultwarden/password.age".publicKeys = users ++ bicboye;
}
