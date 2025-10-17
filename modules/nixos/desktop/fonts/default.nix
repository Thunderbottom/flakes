{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.desktop.fonts = {
    enable = lib.mkEnableOption "Enable desktop font configuration";

    enableDefaultFonts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the default comprehensive font collection";
    };

    extraFonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional fonts to install";
    };
  };

  config = lib.mkIf config.snowflake.desktop.fonts.enable {
    fonts = {
      fontDir.enable = true;
      packages =
        (lib.optionals config.snowflake.desktop.fonts.enableDefaultFonts (
          with pkgs;
          [
            cantarell-fonts
            corefonts
            dejavu_fonts
            fira
            fira-code
            fira-code-symbols
            fira-go
            google-fonts
            hack-font
            ibm-plex
            inconsolata
            inter
            iosevka
            liberation_ttf
            libertine
            libre-baskerville
            material-design-icons
            mplus-outline-fonts.githubRelease
            nerd-fonts.fira-code
            nerd-fonts.jetbrains-mono
            nerd-fonts.symbols-only
            nerd-fonts.sauce-code-pro
            nerd-fonts.ubuntu-mono
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
            noto-fonts-extra
            powerline-fonts
            proggyfonts
            source-serif
            roboto
            ubuntu_font_family
            vistafonts
            work-sans
          ]
        ))
        ++ config.snowflake.desktop.fonts.extraFonts;

      fontconfig.enable = true;
    };
  };
}
