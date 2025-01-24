_: _self: super: let
  version = "0.36.3";
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
            hash = "sha256-ZAKVjBjffinOyHhzln/ny7tooZwtKHfMEDb/Uy0k6Gw=";
          };
          vendorHash = "sha256-xZz2JkD3yD7tuXVFlMm2g1hRBItkGmO9OvnLdUfqai0=";
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
