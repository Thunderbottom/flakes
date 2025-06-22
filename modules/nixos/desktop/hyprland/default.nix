{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.desktop.hyprland = {
    enable = lib.mkEnableOption "Enable the Hyprland Desktop Environment";
  };

  config = lib.mkIf config.snowflake.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
    programs.hyprlock.enable = true;

    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
    environment.systemPackages = with pkgs; [
      bibata-cursors
      mako
      wofi
    ];

    security.polkit.enable = true;
    security.pam.services.hyprlock = {
      fprintAuth = false;
    };

    snowflake.user.extraGroups = [
      "audio"
      "input"
      "video"
    ];
  };
}
