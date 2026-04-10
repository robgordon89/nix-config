{ inputs, ... }:
let
  overlayFiles = builtins.filter (file: file != "default.nix") (builtins.attrNames (builtins.readDir ./.));
  overlayList = map (file: import ./${file} { inherit inputs; }) overlayFiles;
in
{
  default = final: prev:
    builtins.foldl' (acc: overlay: acc // (overlay final prev)) { } overlayList;
}
