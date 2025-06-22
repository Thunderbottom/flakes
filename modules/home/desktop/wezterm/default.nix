{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.desktop.wezterm.enable = lib.mkEnableOption "Enable wezterm home configuration";

  config = lib.mkIf config.snowflake.desktop.wezterm.enable {
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;

      extraConfig = ''
        local wezterm = require 'wezterm'

        local function BaseName(s)
          return string.gsub(s, '(.*[/\\])(.*)', '%2')
        end

        wezterm.on('format-tab-title', function(tab)
        local title = BaseName(tab.active_pane.foreground_process_name)
        if title and #title > 0 then
          return ' ' .. BaseName(tab.active_pane.foreground_process_name) .. ' '
        end
          return ' ' .. tab.active_pane.title .. ' '
        end)

        return {
          font = wezterm.font 'JetBrains Mono',
          font_size = 14.0,

          cursor_blink_rate = 800,

          color_scheme = "ayu",
          use_fancy_tab_bar = false,
          window_decorations = "NONE",

          check_for_updates = false,
        }
      '';
    };
  };
}
