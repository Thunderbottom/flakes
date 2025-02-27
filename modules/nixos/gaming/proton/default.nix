{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.gaming.proton.enable = lib.mkEnableOption "Enable proton and related services for gaming";

  config = lib.mkIf config.${namespace}.gaming.proton.enable {
    # Enable gamemode.
    # Adds optimizations for games that run through wine/proton.
    programs.gamemode.enable = true;

    # Install bottles, heroic launcher, and mangohud
    # Bottles: run games like on native windowss
    # heroic: launcher for epic games, gog, and other stuff
    # mangohud: shows an overlay for FPS, CPU/GPU temperatures in game.
    ${namespace} = {
      extraPackages = with pkgs; [bottles heroic mangohud];
      # Add user to the gamemode group.
      user.extraGroups = ["gamemode"];
    };
  };
}
