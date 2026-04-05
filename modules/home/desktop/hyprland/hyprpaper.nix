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
        wallpaper = [
          {
            monitor = "";
            path = "/home/chnmy/Pictures/Wallpapers/manga-cutouts.jpg";
            fit_mode = "cover";
          }
        ];
      };
    };
  };
}
