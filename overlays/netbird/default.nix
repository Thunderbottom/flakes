_: _self: super: let
  version = "0.28.8";
in {
  netbird = super.netbird.override {
    buildGoModule = args:
      super.buildGoModule (
        args
        // {
          inherit version;
          src = super.fetchFromGitHub {
            owner = "netbirdio";
            repo = "netbird";
            rev = "v${version}";
            hash = "sha256-DfY8CVBHgE/kLALKNzSgmUxM0flWLesU0XAgVsHHLKc=";
          };
          vendorHash = "sha256-CqknRMijAkWRLXCcIjRBX2wB64+RivD/mXq28TqzNjg=";
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
