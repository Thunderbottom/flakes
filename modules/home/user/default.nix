{
  config,
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.snowfallorg.user.enable {
    programs.eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = config.${namespace}.development.git.enable;
      icons = "auto";
    };

    # Enable faster, indexed search for nixpkgs.
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    # Allow home-manager to manage itself.
    programs.home-manager.enable = true;

    # Enable fuzzy finder.
    programs.fzf.enable = true;

    # Enable faster, smarter `cd`.
    programs.zoxide.enable = true;

    home.file = {
      # Set allow unfree in user home nix config.
      ".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";

      # Set sane nano defaults.
      ".nanorc".text = "set constantshow # Show linenumbers -c as default";
    };

    # Set the EDITOR environment variable.
    home.sessionVariables.EDITOR =
      if config.${namespace}.development.helix.enable then "hx" else "nano";

    # Show activation change diff for new builds.
    home.activation.report-changes = inputs.home-manager.lib.hm.dag.entryAnywhere ''
      ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
    '';
  };
}
