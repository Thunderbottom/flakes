{
  config,
  # desktop,
  # lib,
  pkgs,
  ...
}: let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [];
  # ++ lib.optionals (desktop != null) [
  #   ../../desktop/chromium.nix
  #   ../../desktop/chromium-extensions.nix
  #   ../../desktop/obs-studio.nix
  #   ../../desktop/${desktop}-apps.nix
  # ];

  environment.localBinInPath = true;
  environment.systemPackages = [];

  users.users.blurryface = {
    description = "Blurryface";
    extraGroups =
      [
        "networkmanager"
        "users"
        "wheel"
      ]
      ++ ifExists [
        "docker"
        "lxd"
        "podman"
      ];
    # mkpasswd -m sha-512
    hashedPassword = "$y$j9T$ab7R9O2uUPI.ctGSVWgMg0$eA2Eh2lP7XxJpslkxSIy8AJQvpkvwJKwSqK9B5TOXS3";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQWA+bAwpm9ca5IhC6q2BsxeQH4WAiKyaht48b7/xkN cc@predator"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJnFvU6nBXEuZF08zRLFfPpxYjV3o0UayX0zTPbDb7C cc@eden"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3PeMbehJBkmv8Ee7xJimTzXoSdmAnxhBatHSdS+saM chnmy@bastion"
    ];
    packages = [pkgs.home-manager];
    shell = pkgs.fish;
  };
}
