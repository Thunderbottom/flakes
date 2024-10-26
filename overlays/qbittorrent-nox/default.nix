_: _self: super: let
  version = "4.6.7";
in {
  qbittorrent-nox = super.qbittorrent-nox.overrideAttrs (finalAttrs: previousAttrs: {
    inherit version;

    src = super.fetchFromGitHub {
      owner = "qbittorrent";
      repo = "qBittorrent";
      rev = "release-${version}";
      hash = "sha256-vUC8YIuyoGnl46FajfJG/XFXG+2lM9EaHWl2Hfo3T7c=";
    };

    cmakeFlags = (previousAttrs.cmakeFlags or []) ++ ["-DQT6=ON"];
  });
}
