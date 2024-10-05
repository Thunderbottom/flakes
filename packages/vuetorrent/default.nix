{
  pkgs,
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = "vuetorrent";
  version = "2.13.3";

  src = pkgs.fetchurl {
    url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
    sha256 = "sha256-MmzJhzRqlYhcHbvz4ycCobclZ9Idpranyh+doDEdoh8=";
  };

  buildInputs = with pkgs; [unzip];

  unpackPhase = ''
    unzip $src
  '';

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/
    cp -r vuetorrent/public/ $out/
  '';

  meta = with lib; {
    description = "The sleekest looking WEBUI for qBittorrent made with Vuejs! ";
    homepage = "https://github.com/WDaan/VueTorrent";
    license = [licenses.gpl3Only];
    platforms = ["x86_64-darwin" "aarch64-darwin" "aarch64-linux" "x86_64-linux"];
  };
}
