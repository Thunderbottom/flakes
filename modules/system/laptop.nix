{ homeManager, nixos, ... }:
{
  flake.modules.nixos.laptop =
    { config, ... }:
    {
      imports = [ nixos.base ];

      networking.networkmanager = {
        enable = true;
        wifi.powersave = false;
      };
      systemd.services.NetworkManager-wait-online.enable = false;
      services.resolved.enable = true;
      users.users.${config.profile.username}.extraGroups = [ "networkmanager" ];

      powerManagement.powertop.enable = true;

      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/" ];
      };

      home-manager.users.${config.profile.username}.imports = [ homeManager.chnmy ];
    };
}
