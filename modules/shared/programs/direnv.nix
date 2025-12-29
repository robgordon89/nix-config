{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    package = pkgs.stable.direnv;

    nix-direnv = {
      enable = true;
    };

    config = {
      hide_env_diff = true;
    };
  };
}
