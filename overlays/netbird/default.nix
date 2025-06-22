_final: prev:
let
  version = "0.43.0";
in
{
  netbird = prev.netbird.overrideAttrs (_old: {
    inherit version;
    src = prev.fetchFromGitHub {
      owner = "netbirdio";
      repo = "netbird";
      rev = "v${version}";
      hash = "sha256-HmNd5MyplQ8iwpaxhEnomASIwx4VE3Qv70sURxqDzdo=";
    };
    vendorHash = "sha256-/iqWVDqQOTFP5OZDrgq5gAH7NmHneQlf5+wAzIyoEPw=";
    ldflags = [
      "-s"
      "-w"
      "-X github.com/netbirdio/netbird/version.version=${version}"
      "-X main.builtBy=nix"
    ];
  });
}
