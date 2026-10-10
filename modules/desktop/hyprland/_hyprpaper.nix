{
  config,
  lib,
  ...
}:
{
  config = {
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
