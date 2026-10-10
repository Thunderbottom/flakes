{ homeManager, nixos, ... }:
{
  # The NNN stack's desktop: niri as the compositor, noctalia as the shell.
  # Registers an extra session in the display manager, so it can sit beside GNOME.
  flake.modules.nixos.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ nixos.desktop ];

      config = {
        programs.niri.enable = true;
        services.displayManager.gdm.enable = lib.mkDefault true;

        environment.systemPackages = with pkgs; [
          wl-clipboard
          xwayland-satellite
        ];

        users.users.${config.profile.username}.extraGroups = [
          "audio"
          "input"
          "video"
        ];

        home-manager.users.${config.profile.username}.imports = [ homeManager.niri ];
      };
    };

  flake.modules.homeManager.niri =
    { lib, pkgs, ... }:
    {
      programs.noctalia = {
        enable = true;
        # Noctalia renders niri's focus ring, border and Alt+Tab highlight colours
        # into ~/.config/niri/noctalia.kdl, which config.kdl includes below.
        settings.theme.templates = {
          enable_builtin_templates = true;
          builtin_ids = [ "niri" ];
        };
      };

      # niri refuses to load a config whose include is missing, so make sure the
      # file exists before noctalia has generated it for the first time.
      home.activation.noctaliaNiriColors = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        [ -e "$HOME/.config/niri/noctalia.kdl" ] || touch "$HOME/.config/niri/noctalia.kdl"
      '';

      xdg.configFile."niri/config.kdl".text = ''
        spawn-at-startup "noctalia"
        prefer-no-csd

        debug {
          // Lets Noctalia focus windows it activates
          honor-xdg-activation-with-invalid-serial true
        }

        input {
            keyboard {
                xkb {
                    layout "us"
                }
            }
            touchpad {
                tap
                dwt
                natural-scroll
            }
            mouse {
                accel-profile "flat"
            }
        }

        output "eDP-1" {
          scale 1.25
        }

        layout {
            gaps 12
            center-focused-column "never"
            default-column-width { proportion 0.5; }
            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            // Colours come from noctalia.kdl; a border follows the rounded corners, a ring doesn't
            focus-ring { off; }
            border { width 2; }

            shadow {
                on
                softness 30
                spread 4
                offset x=0 y=6
                color "#00000050"
            }
        }

        window-rule {
            geometry-corner-radius 12
            clip-to-geometry true
        }

        // Smaller workspaces in the overview
        overview {
            zoom 0.5
        }

        animations {
            workspace-switch {
                spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
            }
            window-open {
                duration-ms 180
                curve "ease-out-expo"
            }
        }

        hotkey-overlay {
            skip-at-startup
        }

        // Alt+Tab switcher; niri's defaults are max-height 480 and max-scale 0.5
        recent-windows {
            previews {
                max-height 300
                max-scale 0.4
            }
        }

        cursor {
            xcursor-theme "Bibata-Modern-Classic"
            xcursor-size 24
        }

        binds {
            // Noctalia, see https://docs.noctalia.dev/noctalia/compositor-settings/niri/
            Mod+Space { spawn-sh "noctalia msg panel-toggle launcher"; }
            Mod+S { spawn-sh "noctalia msg panel-toggle control-center"; }
            Mod+Comma { spawn-sh "noctalia msg settings-toggle"; }
            Mod+L { spawn-sh "noctalia msg session lock"; }
            XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "noctalia msg volume-up"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn-sh "noctalia msg volume-down"; }
            XF86AudioMute allow-when-locked=true { spawn-sh "noctalia msg volume-mute"; }
            XF86MonBrightnessUp allow-when-locked=true { spawn-sh "noctalia msg brightness-up"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn-sh "noctalia msg brightness-down"; }

            Mod+Return { spawn "${pkgs.ghostty}/bin/ghostty"; }
            Mod+Q { close-window; }
            Mod+Shift+E { quit; }

            Mod+Left { focus-column-left; }
            Mod+Right { focus-column-right; }
            Mod+Up { focus-window-or-workspace-up; }
            Mod+Down { focus-window-or-workspace-down; }
            Mod+Shift+Left { move-column-left; }
            Mod+Shift+Right { move-column-right; }
            Mod+Shift+Up { move-window-up-or-to-workspace-up; }
            Mod+Shift+Down { move-window-down-or-to-workspace-down; }

            Mod+R { switch-preset-column-width; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }
            Mod+V { toggle-window-floating; }

            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }

            Print { screenshot; }
        }

        switch-events {
            lid-close { spawn "noctalia" "msg" "session" "lock-and-suspend"; }
        }

        include "noctalia.kdl"
      '';
    };
}
