{ nixos, ... }:
{
  flake.modules.nixos.arr = {
    imports = [
      nixos.jellyfin
      nixos.seerr
      nixos.prowlarr
      nixos.radarr
      nixos.sonarr
      nixos.sabnzbd
      nixos.qbittorrent-nox
    ];

  };
}
