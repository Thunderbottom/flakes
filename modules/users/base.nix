{ generic, ... }:
{
  flake.modules.homeManager.base =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      imports = [ generic.profile ];

      programs.eza = {
        enable = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
        icons = "auto";
      };

      programs.nix-index = {
        enable = true;
        enableFishIntegration = true;
      };

      programs.home-manager.enable = true;

      programs.fzf = {
        enable = true;
        historyWidget.command = "";
      };

      programs.zoxide.enable = true;

      home.file = {
        ".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";

        ".nanorc".text = "set constantshow # Show linenumbers -c as default";
      };

      home.sessionVariables.EDITOR = "hx";

      home.activation.report-changes = inputs.home-manager.lib.hm.dag.entryAnywhere ''
        if [ -v oldGenPath ]; then
          ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
        fi
      '';
    };
}
