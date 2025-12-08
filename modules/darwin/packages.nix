{ pkgs, hostConfig ? { extraHomeManagerPackages = [ ]; } }:
with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs hostConfig; };
in
shared-packages
++ [
  # Darwin specific packages
  tart
  packer
]
