{
  flake.modules.nixos.fonts =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        fonts = {
          fontDir.enable = true;
          packages = with pkgs; [
            cantarell-fonts
            corefonts
            dejavu_fonts
            fira
            fira-code
            fira-code-symbols
            (google-fonts.override {
              fonts = [
                "Barlow"
                "Cabin"
                "Crimson Text"
                "DM Sans"
                "Josefin Sans"
                "Karla"
                "Lato"
                "Libre Franklin"
                "Lora"
                "Manrope"
                "Merriweather"
                "Montserrat"
                "Mulish"
                "Nunito"
                "Open Sans"
                "Oswald"
                "Outfit"
                "Playfair Display"
                "Poppins"
                "PT Sans"
                "PT Serif"
                "Quicksand"
                "Raleway"
                "Roboto Mono"
                "Roboto Slab"
                "Rubik"
                "Source Code Pro"
                "Source Sans 3"
                "Space Grotesk"
              ];
            })
            hack-font
            ibm-plex
            inconsolata
            inter
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
            noto-fonts-color-emoji
            powerline-fonts
            proggyfonts
            source-serif
            roboto
            ubuntu-classic
            vista-fonts
            work-sans
          ];

          fontconfig.enable = true;
        };
      };
    };
}
