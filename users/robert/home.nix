{ inputs, pkgs, ... }:
{
  home = {
    stateVersion = "24.11";
    packages = with pkgs;
      [
        bob
      ];
  };

  imports = [
    ../shared/programs/neovim
  ];
}
