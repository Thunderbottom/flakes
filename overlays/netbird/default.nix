_: _self: super: let
  version = "0.31.0";
in {
  netbird = super.netbird.override {
    buildGoModule = args:
      super.buildGo123Module (
        args
        // {
          inherit version;
          src = super.fetchFromGitHub {
            owner = "netbirdio";
            repo = "netbird";
            rev = "v${version}";
            hash = "sha256-e3oiIVma4p3tAfDUwKC9zzgTWDjqXZSWsykR47eE+kE=";
          };
          vendorHash = "sha256-kEwGJ2+xe7ct9ckMAE4l+2cBYcUXpoDVM3DohtzHqeY=";
          ldflags = [
            "-s"
            "-w"
            "-X github.com/netbirdio/netbird/version.version=${version}"
            "-X main.builtBy=nix"
          ];
        }
      );
  };
}
