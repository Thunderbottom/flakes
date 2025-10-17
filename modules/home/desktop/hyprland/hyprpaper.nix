{
  config,
  lib,
  ...
}:
{
  options.snowflake.desktop.hyprpaper.enable =
    lib.mkEnableOption "Enable hyprpaper home configuration";

  config = lib.mkIf config.snowflake.desktop.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;

      settings = {
        preload = [ "/home/chnmy/Pictures/Wallpapers/manga-cutouts.jpg" ];
        wallpaper = [ ",/home/chnmy/Pictures/Wallpapers/manga-cutouts.jpg" ];
      };
    };
  };
}
