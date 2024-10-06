_: _self: super: let
  version = "0.30.0";
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
            hash = "sha256-YtKGiF45fNoiYQFTE3NReUaosRGDJOyjfqtc+tBKopI=";
          };
          vendorHash = "sha256-t6kqEmL2lKKYlqxaQ1OsAvB3BSmmyfogghGoE9jw+AI=";
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
