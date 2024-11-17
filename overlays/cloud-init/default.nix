_: _self: super: let
  version = "24.3.1";
in {
  cloud-init = super.cloud-init.overridePythonAttrs (oldAttrs: {
    inherit version;
    src = super.fetchFromGitHub {
      owner = "canonical";
      repo = "cloud-init";
      rev = "refs/tags/${version}";
      hash = "sha256-AU04N8P094Gh6lTLRuWMdCrNOalDoRUP9FlZWrrW1gE=";
    };
    doCheck = false;
  });
}
