{ inputs, pkgs, ... }:
{
  home = {
    stateVersion = "24.11";
    packages = with pkgs;
      [
        bob
        terraform
        poetry
      ];
  };

  imports = [
    ../shared/programs/zsh
    ../shared/programs/git
    ../shared/programs/neovim
    ../shared/programs/fd
    ../shared/programs/hammerspoon
  ];
}
