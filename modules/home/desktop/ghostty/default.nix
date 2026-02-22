{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.desktop.ghostty.enable = lib.mkEnableOption "Enable ghostty home configuration";

  config = lib.mkIf config.snowflake.desktop.ghostty.enable {
    programs.ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;

      settings = {
        theme = "Ayu";
        bold-is-bright = true;
        cursor-style = "bar";
        font-family = "JetBrains Mono";
        window-padding-x = 2;
        window-padding-y = 2;
        working-directory = "home";
        window-inherit-working-directory = false;
        shell-integration-features = [
          "sudo"
          "ssh-env"
          "ssh-terminfo"
        ];
      };
    };
  };
}
