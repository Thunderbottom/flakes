_: _self: super: let
  version = "0.31.1";
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
            hash = "sha256-tSMzLnqPwbMU/3k0JnubtWJ6GtaCtewBmBzUWrDocDY=";
          };
          vendorHash = "sha256-XzJ+FzGlJpnRjDt0IDbe1i7zCEDgy0L9hE/Ltqo+SoE=";
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
