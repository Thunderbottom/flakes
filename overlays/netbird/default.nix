_final: prev:
let
  version = "0.48.0";
in
{
  netbird = prev.netbird.overrideAttrs (_old: {
    inherit version;
    src = prev.fetchFromGitHub {
      owner = "netbirdio";
      repo = "netbird";
      rev = "v${version}";
      hash = "sha256-FAkV3JFYaNwlmUN5fATLSL2WtcYLS6mo9o/zYpt1NMk=";
    };
    vendorHash = "sha256-t/X/muMwHVwg8Or+pFTSEQEsnkKLuApoVUmMhyCImWI=";
    ldflags = [
      "-s"
      "-w"
      "-X github.com/netbirdio/netbird/version.version=${version}"
      "-X main.builtBy=nix"
    ];
  });
}
