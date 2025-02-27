{
  config,
  lib,
  namespace,
  ...
}: let
  # Redefine gitIniTyp.
  # ref: https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix
  gitIniType = with lib.types; let
    primitiveType = either str (either bool int);
    multipleType = either primitiveType (listOf primitiveType);
    sectionType = attrsOf multipleType;
    supersectionType = attrsOf (either multipleType sectionType);
  in
    attrsOf supersectionType;
in {
  options.${namespace}.development.git = {
    enable = lib.mkEnableOption "Enable development git configuration";

    user.name = lib.mkOption {
      type = lib.types.str;
      description = "Real name for the work git profile";
    };
    user.email = lib.mkOption {
      type = lib.types.str;
      description = "Email for the work git profile";
    };
    user.signingKey = lib.mkOption {
      type = lib.types.str;
      description = "Public GPG Key for the work git profile";
    };

    work.enable = lib.mkEnableOption "Enable work git configuration";
    work.path = lib.mkOption {
      type = lib.types.str;
      description = "Absolute path to apply the work git configuration.";
    };
    work.extraConfig = lib.mkOption {
      type = lib.types.either lib.types.lines gitIniType;
      default = {};
      description = "Additional configuration for work git.";
    };
    work.email = lib.mkOption {
      type = lib.types.str;
      description = "Email for the work git profile";
    };
  };

  config = lib.mkIf config.${namespace}.development.git.enable {
    programs.git = {
      enable = true;

      delta = {
        enable = true;
        options = {
          diff-so-fancy = true;
          line-numbers = true;
          true-color = "always";
        };
      };

      extraConfig =
        {
          init.defaultBranch = "main";
          commit.gpgSign = true;
          diff.algorithm = "histogram";
          gc.writeCommitGraph = true;

          # Do not `git fetch && git merge` or `git fetch && git rebase`
          # on default `git pull behavior`.
          pull.ff = "only";
          pull.rebase = false;

          # Enable REuse REcorded REsolution for git merge conflicts.
          rerere.enabled = true;

          user.name = config.${namespace}.development.git.user.name;
          user.email = config.${namespace}.development.git.user.email;
          user.signingKey = config.${namespace}.development.git.user.signingKey;
        }
        // config.${namespace}.development.git.work.extraConfig;

      # Global gitignore configuration.
      ignores = [
        "*~"
        ".#*"
      ];
      includes = lib.mkIf config.${namespace}.development.git.work.enable [
        # Enable work git configuration in specific directories.
        # This allows existence of two different gitconfigs based on directories.
        # For this, structuring the git repositories into directories based on
        # origin is an ideal workflow.
        # Example:
        # ~/workspace/github.com: personal git workflow.
        # ~/workspace/git.work.example: $WORK git workflow.
        # Setting config.${namespace}.work.git.workpath = "~/workspace/git.work.example"
        # would apply the following configuration to only
        # the ~/workspace.git.work.example folder.
        {
          condition = "gitdir:${config.${namespace}.development.git.work.path}";
          contents = {
            commit.gpgSign = true;
            user.email = config.${namespace}.development.git.work.email;
            user.name = config.${namespace}.development.git.user.name;
            user.signingKey = config.${namespace}.development.git.user.signingKey;
          };
        }
      ];
    };
  };
}
