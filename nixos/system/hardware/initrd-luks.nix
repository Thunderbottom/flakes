_: {
  # Enable remote LUKS Unlocking
  # - https://nixos.wiki/wiki/Remote_LUKS_Unlocking
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 22;
      shell = "/bin/cryptsetup-askpass";
      hostKeys = ["/etc/ssh/ssh_host_ed25519_key"];
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN cc@predator"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C cc@eden"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM chnmy@bastion"
      ];
    };
  };
  boot.initrd.availableKernelModules = ["r8169"];
  boot.kernelParams = ["ip=dhcp"];
}
