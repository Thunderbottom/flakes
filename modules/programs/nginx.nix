{...}: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "chinmaydpai@gmail.com";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedTlsSettings = true;
  };
}
