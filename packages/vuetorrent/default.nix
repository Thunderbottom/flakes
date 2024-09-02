{
  pkgs,
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = "vuetorrent";
  version = "2.10.2";

  src = pkgs.fetchurl {
    url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
    sha256 = "sha256-pJzj3jHXmpKca1zyOTlzUQvp7/LtjjMGNt9SMDo89yo=";
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
