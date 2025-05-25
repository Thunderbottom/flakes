{
  config,
  lib,
  namespace,
  ...
}:
{
  options.${namespace}.services.arr = {
    enable = lib.mkEnableOption "Enable arr suite configuration";
    monitoring = {
      enable = lib.mkEnableOption "Enable monitoring for arr suite";
      sonarrApiKeyFile = lib.mkOption {
        description = "Age module containing the sonarr API Key to use for monitoring";
      };
      radarrApiKeyFile = lib.mkOption {
        description = "Age module containing the radarr API Key to use for monitoring";
      };
    };
  };

  config = lib.mkIf config.${namespace}.services.arr.enable {
    ${namespace}.services = {
      jellyfin.enable = true;
      jellyseerr.enable = true;

      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;

      sabnzbd.enable = true;
      qbittorrent-nox = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
