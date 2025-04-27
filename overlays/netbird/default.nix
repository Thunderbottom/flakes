_: _self: super:
let
  # version = "0.37.1";
  version = "0.43.0";
in
{
  netbird = super.netbird.overrideAttrs (old: {
    inherit version;
    src = super.fetchFromGitHub {
      owner = "netbirdio";
      repo = "netbird";
      rev = "v${version}";
      hash = "sha256-HmNd5MyplQ8iwpaxhEnomASIwx4VE3Qv70sURxqDzdo=";
      # hash = "sha256-5+R0Y/xPgnVH53p1vtY65tOqePWQVOMR4oY1yOOFHK4=";
    };
    vendorHash = "sha256-/iqWVDqQOTFP5OZDrgq5gAH7NmHneQlf5+wAzIyoEPw=";
    # vendorHash = "sha256-DGvDkkdM8WaaR5FQwZgKn2n1JEDeqUegZxeAIxniJ5A=";
    ldflags = [
      "-s"
      "-w"
      "-X github.com/netbirdio/netbird/version.version=${version}"
      "-X main.builtBy=nix"
    ];
  });
}
