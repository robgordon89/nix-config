{ inputs, pkgs, ... }:
{
  home = {
    stateVersion = "24.11";
    packages = with pkgs;
      [
        fd
        bob
      ];
  };

  imports = [
    ../shared/programs/neovim
    ../shared/programs/fd
  ];
}
