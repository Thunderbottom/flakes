let
  codingcoffee = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN cc@predator"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C cc@eden"
  ];
  thunderbottom = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM"];
  trench = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBsciEMPwLAYtbHNkdedjhSrb66fFQ46lgnVGssCuiLH";

  servers = [trench];
  users = thunderbottom ++ codingcoffee;
in {
  "gitea.age".publicKeys = users ++ servers;
  "vaultwarden.age".publicKeys = users ++ servers;
}
