{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nordwand-mono";
  version = "1.3.4";

  src = fetchurl {
    url = "https://github.com/tywr/Nordwand-Mono/releases/download/${finalAttrs.version}/NordwandMono-TTF.zip";
    hash = "sha256-If60DYDSQcjaTZnGHO9k++6svFlT9/LMon/xvZzVLAE=";
  };

  # The release archive contains only fonts; include the upstream font license.
  fontLicense = fetchurl {
    url = "https://raw.githubusercontent.com/tywr/Nordwand-Mono/${finalAttrs.version}/LICENSE-FONT.txt";
    hash = "sha256-4OST7a5xStW7JDo0bz/UXs3ZSgBYQRgpfy0F4PYYfTg=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t "$out/share/fonts/truetype"
    install -Dm644 "$fontLicense" "$out/share/licenses/nordwand-mono/LICENSE-FONT.txt"
    runHook postInstall
  '';

  meta = {
    description = "Compact neo-grotesk monospaced font designed for coding";
    homepage = "https://github.com/tywr/Nordwand-Mono";
    changelog = "https://github.com/tywr/Nordwand-Mono/releases/tag/${finalAttrs.version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
