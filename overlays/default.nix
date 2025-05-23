{ inputs, ... }:
let
  overlayFiles = builtins.filter (file: file != "default.nix") (builtins.attrNames (builtins.readDir ./.));
  importOverlay = file: import ./${file} { inherit inputs; };
in
map importOverlay overlayFiles
