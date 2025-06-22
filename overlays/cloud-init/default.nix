_final: prev:
let
  version = "24.3.1";
in
{
  cloud-init = prev.cloud-init.overridePythonAttrs (_oldAttrs: {
    inherit version;
    src = prev.fetchFromGitHub {
      owner = "canonical";
      repo = "cloud-init";
      rev = "refs/tags/${version}";
      hash = "sha256-AU04N8P094Gh6lTLRuWMdCrNOalDoRUP9FlZWrrW1gE=";
    };
    doCheck = false;
  });
}
