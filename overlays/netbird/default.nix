_: _self: super: let
  version = "0.36.5";
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
            hash = "sha256-3k41lydp6bIfANblvdYK07xY/B3SbXwipbLAIUxmf9I=";
          };
          vendorHash = "sha256-30KSccdeQ+DrYjotCR0w0LvY1jCBBJIAy5rKQtSsD9Q=";
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
