{
  flake.modules.homeManager.git =
    {
      config,
      lib,
      ...
    }:
    {
      config = {
        programs = {
          delta = {
            enable = true;
            enableGitIntegration = true;
            options = {
              diff-so-fancy = true;
              line-numbers = true;
              true-color = "always";
            };
          };

          git = {
            enable = true;

            settings = {
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

              user.name = config.profile.fullName;
              user.email = config.profile.email;
              user.signingKey = config.profile.gitKey;
            };

            ignores = [
              "*~"
              ".#*"
            ];
          };
        };
      };
    };
}
