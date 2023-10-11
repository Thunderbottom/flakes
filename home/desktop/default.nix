{pkgs, ...}: {
  imports = [../base];

  home.packages = with pkgs; [
    firefox-nightly-bin
  ];

  programs = {
    # Fish shell
    # Git configuration
    git = {
      userEmail = "chinmay.pai@zerodha.com";
      userName = "Chinmay D. Pai";
      signing = {
        key = "75507BE256F40CED";
        signByDefault = true;
      };

      extraConfig = {
        url."ssh://git@gitlab.zerodha.tech:2280".insteadOf = "https://gitlab.zerodha.tech";
        url."ssh://git@gitlab.zerodha.tech:2280/".insteadOf = "git@gitlab.zerodha.tech:";
      };
    };

    # Terminal emulator for wayland
    wezterm = {
      enable = true;
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
          return tab_info.active_pane.title
        end)

        return {
          font = wezterm.font 'IBM Plex Mono',
          font_size = 12.0,

          cursor_blink_rate = 800,

          color_scheme = "Ayu Dark (Gogh)",
          use_fancy_tab_bar = false,
          window_decorations = "RESIZE",
          xcursor_theme = "Adwaita"
        }
      '';
    };
  };
}
