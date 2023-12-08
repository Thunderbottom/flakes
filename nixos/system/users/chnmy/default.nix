{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports =
    [
      ../../services/nixvim.nix
    ]
    ++ lib.optionals (desktop != null) [
      ../../services/emacs.nix
    ];

  environment.localBinInPath = true;
  environment.systemPackages = with pkgs;
    [
      agenix
      editorconfig-core-c
      fd
      gnumake
      nil
      ripgrep
      terraform
      terraform-ls
      tree
    ]
    ++ lib.optionals (desktop != null) [
      easyeffects
      netbird-ui
    ];

  services = {
    netbird.enable = true;
  };

  users.users.chnmy = {
    description = "Chinmay D. Pai";
    extraGroups =
      [
        "audio"
        "input"
        "networkmanager"
        "users"
        "video"
        "wheel"
      ]
      ++ ifExists [
        "docker"
        "lxd"
        "podman"
      ];
    # mkpasswd -m sha-512
    hashedPassword = "$y$j9T$G75cisWVMV27C2TLIqk0P/$GsICzokHJs.FQ2Yr2rLga9iawMrY3g1SAwe8wYZNY6/";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [];
    packages = [pkgs.home-manager];
    shell = pkgs.fish;
  };
}
