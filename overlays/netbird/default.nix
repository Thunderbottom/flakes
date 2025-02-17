_: _self: super: let
  version = "0.36.6";
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
            hash = "sha256-qXwpYGFAQvOKor/acJJqjgNiFNf2YxDsawFne3dkfYc=";
          };
          vendorHash = "sha256-/8SoQAQoFuuHTi+rTkmQSZxCt9sAl0yDCVccrqlx4VE=";
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
