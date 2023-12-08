{pkgs, ...}: {
  programs = {
    # A modern `ls` alternative
    eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = true;
    };
    # Fish shell
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        ${pkgs.nix-index}/etc/profile.d/command-not-found.sh | source
        ${pkgs.starship}/bin/starship init fish | source
        ${pkgs.zoxide}/bin/zoxide init fish | source
      '';
      plugins = [
        {
          inherit (pkgs.fishPlugins.autopair) src;
          name = "autopair";
        }
      ];
    };
    # Fuzzy finder
    fzf.enable = true;
    # Git configuration
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          diff-so-fancy = true;
          line-numbers = true;
          true-color = "always";
        };
      };
      extraConfig = {
        core.editor = "vim";
        gc.writeCommitGraph = true;
        pull.rebase = false;
      };
      ignores = ["*~" ".#*"];
    };
    home-manager.enable = true;
    # Faster, indexed search for nixpkgs
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    # TODO: replace?
    # Shell Prompt
    starship = {
      enable = true;
      settings = {
        gcloud.disabled = true;
        shlvl.disabled = false;
        username.show_always = true;
        nix_shell = {
          format = "via [☃️ $state( \($name\))](bold blue) ";
          impure_msg = "[impure shell](bold red)";
          pure_msg = "[pure shell](bold green)";
          symbol = "";
          unknown_msg = "[unknown shell](bold yellow)";
        };
      };
    };
    # Terminal multiplexer
    tmux = {
      enable = true;
      shortcut = "a";
      aggressiveResize = true;
      baseIndex = 1;
      newSession = true;
      # Stop tmux+escape craziness.
      escapeTime = 0;
      # Force tmux to use /tmp for sockets (WSL2 compat)
      secureSocket = false;

      extraConfig = ''
        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';
    };
    # Faster, smarter `cd`
    zoxide.enable = true;
  };
}
