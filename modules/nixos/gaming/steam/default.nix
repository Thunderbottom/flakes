{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.gaming.steam.enable = lib.mkEnableOption "Enable steam";

  config = lib.mkIf config.snowflake.gaming.steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
  };
}
