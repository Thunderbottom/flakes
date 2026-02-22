{
  config,
  lib,
  ...
}:
{
  options.snowflake.desktop.waybar.enable = lib.mkEnableOption "Enable waybar home configuration";

  config = lib.mkIf config.snowflake.desktop.waybar.enable {
    programs.waybar = {
      enable = true;
      settings = import ./config.nix;
      style = import ./style.nix;
    };
  };
}
