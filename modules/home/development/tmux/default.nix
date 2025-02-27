{
  config,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.development.tmux.enable = lib.mkEnableOption "Enable tmux core configuration";

  config = lib.mkIf config.${namespace}.development.tmux.enable {
    programs.tmux = {
      enable = true;
      shortcut = "a";
      aggressiveResize = true;
      baseIndex = 1;
      newSession = true;
      escapeTime = 0;
      secureSocket = false;

      extraConfig = ''
        # Set terminal emulator window title
        set -g set-titles on
        set -g set-titles-string "#S:#I.#P #W"

        # Status Bar styles
        set -g status-bg black
        set -g status-fg white
        set -g status-interval 1

        # Show hostname on left side
        set -g status-left-length 30
        set -g status-left '#[fg=colour2][ #[fg=colour10]#h#[fg=colour2] ][#[default] '

        # Set mouse to work
        set-option -g mouse on

        # Show load and date/time on right side
        set -g status-right-length 60
        set -g status-right '#[fg=colour2]][ #[fg=colour11]#(cut -d " " -f 1-4 /proc/loadavg)#[fg=colour2] ][ #[fg=colour14]%Y-%m-%d %H:%M:%S#[fg=colour2] ]#[default]'

        # Center the window list
        set -g status-justify centre

        # Format of window items
        set -g window-status-format ' #I-$ #W '
        set -g window-status-current-format '#[bg=black]#[fg=red,bold](#[fg=white,bold]#I*$ #W#[fg=red,bold])#[default]'

        # Notifying if other windows has activities
        setw -g monitor-activity on
        set -g visual-activity off

        # Easy to remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # 256 Color terminals
        set -g default-terminal "screen-256color"
      '';
    };
  };
}
