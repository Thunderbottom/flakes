_: _self: super: let
  version = "0.32.0";
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
            hash = "sha256-Mo3hhm/SVusz7bTszsxc5gDOXVotvVFzA6Q9RD780Jo=";
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
