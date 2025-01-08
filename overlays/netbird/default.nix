_: _self: super: let
  version = "0.35.2";
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
            hash = "sha256-CvKJiv3CyCRp0wyH+OZejOChcumnMOrA7o9wL4ElJio=";
          };
          vendorHash = "sha256-CgfZZOiFDLf6vCbzovpwzt7FlO9BnzNSdR8e5U+xCDQ=";
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
