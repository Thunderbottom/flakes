{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.development.helix.enable =
    lib.mkEnableOption "Enable helix development configuration";

  config = lib.mkIf config.snowflake.development.helix.enable {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [
        clippy
        nil
        gopls
        gotools
        lldb
        marksman
        nixfmt-rfc-style
        pyright
        ruff
        rust-analyzer
        shellcheck
      ];

      defaultEditor = true;

      settings = {
        theme = "ayu_dark";
        editor = {
          line-number = "relative";
          cursorline = true;
          rulers = [ 120 ];
          color-modes = true;
          true-color = true;
          bufferline = "always";
          completion-replace = true;
          trim-trailing-whitespace = true;
          end-of-line-diagnostics = "hint";

          file-picker.hidden = false;
          soft-wrap.enable = false;

          auto-save = {
            focus-lost = true;
            after-delay = {
              enable = true;
              timeout = 300000;
            };
          };

          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };

          whitespace = {
            render = "all";
            characters = {
              space = "·";
              nbsp = "⍽";
              tab = "→";
              newline = "⤶";
            };
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

          indent-guides.render = true;
        };
      };

      languages = {
        language = [
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.shfmt;
              args = [
                "-i"
                "2"
              ];
            };
          }
          {
            name = "go";
            auto-format = true;
          }
          {
            name = "markdown";
            auto-format = true;
            language-servers = [ "marksman" ];
          }
          {
            name = "nix";
            formatter.command = "nixfmt";
            auto-format = true;
            language-servers = [ "nil" ];
          }
          {
            name = "python";
            auto-format = true;
            language-servers = [
              "pyright"
              "ruff"
            ];
            file-types = [
              "py"
              "pyi"
              "py3"
              "pyw"
              ".pythonstartup"
              ".pythonrc"
            ];
          }
          {
            name = "rust";
            formatter = {
              command = lib.getExe pkgs.rustfmt;
              args = [
                "--edition"
                "2021"
              ];
            };
            language-servers = [ "rust-analyzer" ];
            auto-format = true;
          }
        ];
        language-server = {
          bash-language-server = {
            command = lib.getExe pkgs.bash-language-server;
            args = [ "start" ];
          };
          gopls = {
            command = lib.getExe pkgs.gopls;
            config.gopls.formatting.command = [ "${pkgs.go}/bin/gofmt" ];
          };
          marksman.command = lib.getExe pkgs.marksman;
          nil = {
            command = lib.getExe pkgs.nil;
            config.nil.formatting.command = [
              "${lib.getExe pkgs.nixfmt-rfc-style}"
              "-q"
            ];
          };
          pyright = {
            command = "${pkgs.pyright}/bin/pyright-langserver";
            config.pyright.formatting.command = [
              "${lib.getExe pkgs.black}"
              "-"
              "--quiet"
              "--line-length=88"
            ];
            args = [ "--stdio" ];
          };
          ruff = {
            command = "${pkgs.ruff}/bin/ruff-lsp";
          };
          rust-analyzer = {
            command = lib.getExe pkgs.rust-analyzer;
            config = {
              checkOnSave.command = "clippy";
              cargo.features = "all";
              cargo.unsetTest = [ ];
            };
          };
        };
      };
    };
  };
}
