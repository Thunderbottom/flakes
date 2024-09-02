{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.gaming.steam.enable = lib.mkEnableOption "Enable steam";

  config = lib.mkIf config.snowflake.gaming.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;

      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            pango
            libthai
            harfbuzz
            glxinfo
          ];
      };
    };
  };
}
