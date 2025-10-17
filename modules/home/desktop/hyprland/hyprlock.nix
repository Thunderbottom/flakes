{
  config,
  lib,
  ...
}:
{
  options.snowflake.desktop.hyprlock.enable = lib.mkEnableOption "Enable hyprlock home configuration";

  config = lib.mkIf config.snowflake.desktop.hyprlock.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        background = {
          monitor = "";
          path = "/home/chnmy/Pictures/Wallpapers/manga-cutouts.jpg";
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };

        general = {
          no_fade_in = false;
          grace = 0;
          disable_loading_bar = false;
        };

        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
            color = "rgba(0, 0, 0, 0.9)";
            font_size = 142;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, 250";
            halign = "center";
            valign = "center";
          }

          {
            monitor = "";
            text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
            color = "rgba(0, 0, 0, 0.9)";
            font_size = 28;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, 370";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "$USER";
            color = "rgba(223, 223, 223, 0.8)";
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            font_size = 18;
            font_family = "JetBrainsMono Nerd Font";
            position = "0, -180";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = {
          monitor = "";
          size = "300, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0.9)";
          inner_color = "rgba(0, 0, 0, 0.8)";
          font_color = "rgba(223, 223, 223, 1)";
          fade_on_empty = false;
          font_family = "JetBrainsMono Nerd Font";
          placeholder_text = ''<i><span foreground="##dfdfdf99">Password</span></i>'';
          hide_input = false;
          position = "0, -250";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
