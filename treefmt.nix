{pkgs, ...}: {
  projectRootFile = "flake.nix";

  programs = {
    deadnix = {
      enable = true;
      no-lambda-pattern-names = true;
    };

    nixfmt = {
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };

    prettier.enable = true;

    shfmt = {
      enable = true;
      indent_size = 2;
    };

    statix.enable = true;
    yamlfmt.enable = true;
  };

  settings = {
    on-unmatched = "info";
  };
}
