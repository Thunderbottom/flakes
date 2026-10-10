{ inputs, ... }:
{
  flake.templates = {
    module = {
      path = "${inputs.self}/templates/module";
      description = "Flake template for creating a new nix module";
    };
    desktop = {
      path = "${inputs.self}/templates/desktop";
      description = "Flake template for creating a new desktop configuration";
    };
    server = {
      path = "${inputs.self}/templates/server";
      description = "Flake template for creating a new server configuration";
    };
  };
}
