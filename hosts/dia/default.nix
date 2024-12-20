{ inputs
, lib
, configVars
, configLib
, pkgs
, ...
}:

{
  nix.package = pkgs.nixVersions.latest;

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  imports = lib.flatten [
    (map configLib.relativeToRoot [
      "hosts/common/core"
    ])
  ];

}
