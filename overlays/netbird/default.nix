_: _self: super: let
  version = "0.29.4";
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
            hash = "sha256-W71CE83r/RcPdBjzfT+FSh72UcKcTmIuagkrC1eaeNk=";
          };
          vendorHash = "sha256-CD34U+Z8bUKN0Z4nxIVC+mYDp71Q8q1bmUypRDGgb3U=";
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
