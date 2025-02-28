_: _self: super: let
  version = "0.37.1";
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
            hash = "sha256-5+R0Y/xPgnVH53p1vtY65tOqePWQVOMR4oY1yOOFHK4=";
          };
          vendorHash = "sha256-DGvDkkdM8WaaR5FQwZgKn2n1JEDeqUegZxeAIxniJ5A=";
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
