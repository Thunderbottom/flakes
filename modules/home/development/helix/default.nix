{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.development.helix.enable = lib.mkEnableOption "Enable helix development configuration";

  config = lib.mkIf config.snowflake.development.helix.enable {
    programs.helix = {
      enable = true;
      package = pkgs.helix.overrideAttrs (old: {
        makeWrapperArgs =
          with pkgs;
          old.makeWrapperArgs or [ ]
          ++ [
            "--suffix"
            "PATH"
            ":"
            (lib.makeBinPath [
              alejandra
              nil
              gopls
              gotools
              marksman
              shellcheck
            ])
          ];
      });

      defaultEditor = true;

      settings = {
        theme = "ayu_dark";
        editor = {
          line-number = "relative";
          cursorline = true;
          cursor-shape.insert = "bar";
          scrolloff = 5;
          color-modes = true;
          idle-timeout = 1;
          true-color = true;
          bufferline = "always";
          soft-wrap.enable = true;
          completion-replace = true;
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };

          whitespace.render = "all";
          whitespace.characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⤶";
          };

          gutters = [
            "diagnostics"
            "line-numbers"
            "spacer"
            "diff"
          ];
          statusline = {
            separator = "of";
            left = [
              "mode"
              "selections"
              "file-type"
              "register"
              "spinner"
              "diagnostics"
            ];
            center = [ "file-name" ];
            right = [
              "file-encoding"
              "file-line-ending"
              "position-percentage"
              "spacer"
              "separator"
              "total-line-numbers"
            ];
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };
          indent-guides = {
            render = true;
            rainbow-option = "normal";
          };
        };
      };

      languages = {
        language = [
          {
            name = "go";
            auto-format = true;
          }
          {
            name = "nix";
            formatter.command = "alejandra";
            auto-format = true;
          }
        ];
        language-server = {
          nil = {
            command = lib.getExe pkgs.nil;
            config.nil.formatting.command = [
              "${lib.getExe pkgs.alejandra}"
              "-q"
            ];
          };
          gopls = {
            command = lib.getExe pkgs.gopls;
            config.gopls.formatting.command = [ "${pkgs.go}/bin/gofmt" ];
          };
        };
      };
    };
  };
}
