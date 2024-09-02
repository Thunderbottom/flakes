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

  smolboye = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQFm91hLes24sYbq96zD52mDrrr1l2F2xstcfAEg+qI"];
  bicboye = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsciEMPwLAYtbHNkdedjhSrb66fFQ46lgnVGssCuiLH"];

  servers = bicboye ++ smolboye;
  users = thunderbottom ++ codingcoffee;
in {
  "machines/thonkpad/password.age".publicKeys = thunderbottom ++ thonkpad;
  "machines/thonkpad/root-password.age".publicKeys = thunderbottom ++ thonkpad;
  "machines/bicboye/password.age".publicKeys = thunderbottom ++ bicboye;
  "machines/bicboye/root-password.age".publicKeys = thunderbottom ++ bicboye;
  "services/backup/environment.age".publicKeys = thunderbottom ++ bicboye;
  "services/backup/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/gitea/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/maddy/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/maddy/user-watashi.age".publicKeys = thunderbottom ++ servers;
  "services/miniflux/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/paperless/password.age".publicKeys = users ++ bicboye;
  "services/vaultwarden/password.age".publicKeys = users ++ bicboye;
}
