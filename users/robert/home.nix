{ inputs, pkgs, ... }:
{
  home = {
    stateVersion = "24.11";
    packages = with pkgs;
      [
        bob
        terraform
      ];
  };
 
  imports = [
    ../shared/programs/neovim
    ../shared/programs/fd
  ];
}
