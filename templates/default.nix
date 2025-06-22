{ self, ... }:
{
  flake = {
    templates = {
      module = {
        path = "${self}/templates/module";
        description = "Flake template for creating a new nix module";
      };
      desktop = {
        path = "${self}/templates/desktop";
        description = "Flake template for creating a new desktop configuration";
      };
      server = {
        path = "${self}/templates/server";
        description = "Flake template for creating a new server configuration";
      };
    };
  };
}
