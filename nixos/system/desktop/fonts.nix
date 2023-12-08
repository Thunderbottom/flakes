{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      aileron
      cantarell-fonts
      corefonts
      dejavu_fonts
      dina-font
      fira-code
      fira-code-symbols
      google-fonts
      hack-font
      ibm-plex
      inconsolata
      inter
      iosevka
      libertine
      libre-baskerville
      material-design-icons
      mplus-outline-fonts.githubRelease
      noto-fonts-cjk
      powerline-fonts
      proggyfonts
      roboto
      vistafonts
    ];
  };
}
