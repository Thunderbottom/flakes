{
  flake.modules.homeManager.ghostty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        programs.ghostty = {
          enable = true;

          settings = {
            theme = "Ayu";
            bold-is-bright = true;
            cursor-style = "bar";
            font-family = "JetBrainsMono Nerd Font";
            window-padding-x = 2;
            window-padding-y = 2;
            working-directory = "home";
            window-inherit-working-directory = false;
            shell-integration-features = [
              "sudo"
              "ssh-env"
              "ssh-terminfo"
            ];
          };
        };
      };
    };
}
