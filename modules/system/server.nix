{
  homeManager,
  lib,
  nixos,
  ...
}:
{
  flake.modules.nixos.server =
    { config, ... }:
    {
      imports = [ nixos.base ];

      powerManagement.cpuFreqGovernor = "performance";

      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/" ];
      };

      profile.username = "server";
      users.users.${config.profile.username}.openssh.authorizedKeys.keys =
        config.profile.sshKeys.users.thunderbottom ++ config.profile.sshKeys.users.codingcoffee;
      home-manager.users.${config.profile.username}.imports = [ homeManager.server ];

      # Higher network connection limits and connection tracking for
      # servers handling many concurrent connections (web servers, proxies).
      boot.kernel.sysctl = {
        "net.ipv4.tcp_max_syn_backlog" = 4096;
        "net.core.netdev_max_backlog" = 5000;
        "net.netfilter.nf_conntrack_max" = lib.mkForce 524288;
      };
    };
}
