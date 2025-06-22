{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.snowflake.desktop.fonts.enable = lib.mkEnableOption "Enable desktop font configuration";

  config = lib.mkIf config.snowflake.desktop.fonts.enable {
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
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
      ];

      fontconfig = {
        enable = true;

        antialias = true;
        defaultFonts = {
          serif = [
            "Noto Serif"
            "Noto Color Emoji"
          ];
          sansSerif = [
            "Noto Sans"
            "Noto Color Emoji"
          ];
          monospace = [
            "JetBrainsMono Nerd Font"
            "Noto Color Emoji"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting = {
          autohint = false;
          enable = true;
          style = "slight";
        };
        subpixel = {
          rgba = "rgb";
          lcdfilter = "light";
        };
      };
    };
  };
}
