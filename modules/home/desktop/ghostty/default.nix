{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options.snowflake.desktop.ghostty.enable = lib.mkEnableOption "Enable ghostty home configuration";

  config = lib.mkIf config.snowflake.desktop.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.system}.default;

      settings = {
        theme = "ayu";
        bold-is-bright = true;
        background = "#0f1419";
        foreground = "#e6e1cf";
        selection-background = "#253340";
        selection-foreground = "#e6e1cf";
        cursor-color = "#f29718";
        cursor-text = "#e6e1cf";
        cursor-style = "bar";
        palette = [
          "0=#000000"
          "1=#ff3333"
          "2=#b8cc52"
          "3=#e7c547"
          "4=#36a3d9"
          "5=#f07178"
          "6=#95e6cb"
          "7=#ffffff"
          "8=#323232"
          "9=#ff6565"
          "10=#eafe84"
          "11=#fff779"
          "12=#68d5ff"
          "13=#ffa3aa"
          "14=#c7fffd"
          "15=#ffffff"
        ];
        font-family = "JetBrains Mono";
      };
    };
  };
}
