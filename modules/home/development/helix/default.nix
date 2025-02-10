{
  config,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.development.helix.enable = lib.mkEnableOption "Enable helix development configuration";

  config = lib.mkIf config.snowflake.development.helix.enable {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [
        alejandra
        nil
        gopls
        gotools
        marksman
        shellcheck
      ];

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
            center = ["file-name"];
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
            name = "bash";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.shfmt;
              args = ["-i" "2"];
            };
          }
          {
            name = "go";
            auto-format = true;
          }
          {
            name = "markdown";
            auto-format = true;
            language-servers = ["marksman"];
          }
          {
            name = "nix";
            formatter.command = "alejandra";
            auto-format = true;
          }
          {
            name = "rust";
            formatter.command = lib.getExe pkgs.rustfmt;
            auto-format = true;
          }
        ];
        language-server = {
          bash-language-server = {
            command = lib.getExe pkgs.bash-language-server;
            args = ["start"];
          };
          gopls = {
            command = lib.getExe pkgs.gopls;
            config.gopls.formatting.command = ["${pkgs.go}/bin/gofmt"];
          };
          marksman.command = lib.getExe pkgs.marksman;
          nil = {
            command = lib.getExe pkgs.nil;
            config.nil.formatting.command = [
              "${lib.getExe pkgs.alejandra}"
              "-q"
            ];
          };
          rust-analyzer = {
            command = lib.getExe pkgs.rust-analyzer;
            config.rust-analyzer = {
              checkOnSave.command = "${pkgs.clippy}/bin/clippy";
              cargo.features = "all";
              cargo.unsetTest = [];
            };
          };
        };
      };
    };
  };
}
