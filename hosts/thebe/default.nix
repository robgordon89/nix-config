{ inputs
, lib
, configVars
, configLib
, pkgs
, ...
}:

{
  nix.package = pkgs.nixVersions.latest;

  system.stateVersion = 5;

  imports = lib.flatten [
    (map configLib.relativeToRoot [
      "hosts/common/core"
    ])
  ];

}
