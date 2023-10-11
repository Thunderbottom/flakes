{
  lib,
  pkgs,
  ...
}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      aileron
      corefonts
      dejavu_fonts
      dina-font
      fira
      fira-code
      fira-code-symbols
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
      nerdfonts
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk
      noto-fonts-emoji
      powerline-fonts
      proggyfonts
      roboto
      vistafonts
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };
}
