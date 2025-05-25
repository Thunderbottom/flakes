# Add support for intro-skipper-button
# Ref: https://wiki.nixos.org/wiki/Jellyfin#Intro_Skipper_plugin
_: _self: super: {
  jellyfin-web = super.jellyfin-web.overrideAttrs (
    _finalAttrs: _previousAttrs: {
      installPhase = ''
        runHook preInstall

        # this is the important line
        sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

        mkdir -p $out/share
        cp -a dist $out/share/jellyfin-web

        runHook postInstall
      '';
    }
  );
}
