{ pkgs }:
with pkgs; let
  shared-packages = import ../../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [
  stable.karabiner-elements
  raycast
  bob
]
