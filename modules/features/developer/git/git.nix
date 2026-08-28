{ ... }:
{
  flake.modules.homeManager.git = { config, pkgs, ... }: {
    # Exposes `git branch-status` via PATH.
    home.packages = [ pkgs.git-branch-status ];

    programs.git = {
      enable = true;
      package = pkgs.git;
      signing = {
        key = config.meta.sshPublicKey;
        signByDefault = true;
      };
      ignores = import ./_git-ignores.nix;
      settings = import ./_git-extra.nix // {
        user = {
          name = config.meta.fullName;
          email = config.meta.email;
        };
        alias = import ./_git-aliases.nix;
      };
    };
  };
}
