{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.gaming.proton.enable = lib.mkEnableOption "Enable proton and related services for gaming";

  config = lib.mkIf config.snowflake.gaming.proton.enable {
    # Enable gamemode.
    # Adds optimizations for games that run through wine/proton.
    programs.gamemode.enable = true;

    # Install bottles, heroic launcher, and mangohud
    # Bottles: run games like on native windowss
    # heroic: launcher for epic games, gog, and other stuff
    # mangohud: shows an overlay for FPS, CPU/GPU temperatures in game.
    snowflake.extraPackages = with pkgs; [bottles heroic mangohud];
  };
}
