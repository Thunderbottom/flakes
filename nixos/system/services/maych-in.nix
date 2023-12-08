{pkgs, ...}: {
  services.nginx = {
    virtualHosts = {
      "maych.in" = {
        serverName = "maych.in";
        enableACME = true;
        forceSSL = true;
        root = pkgs.maych-in;
      };
    };
  };
}
