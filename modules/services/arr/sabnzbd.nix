{ nixos, ... }:
{
  flake.modules.nixos.sabnzbd =
    {
      config,
      lib,
      ...
    }:
    {
      imports = [ nixos.backup-registry ];

      config = {
        services.sabnzbd.enable = true;
        services.sabnzbd.group = "media";
        services.sabnzbd.openFirewall = true;

        # This needs to be changed as per the port specified in the configuration.
        networking.firewall.allowedTCPPorts = [ 8085 ];

        backups.sabnzbd.paths = [
          "/var/lib/${config.services.sabnzbd.stateDir}/sabnzbd.ini"
        ];
      };
    };
}
