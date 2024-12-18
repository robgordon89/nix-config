{ inputs
, lib
, configVars
, configLib
, pkgs
, ...
}:

{
  nix.package = pkgs.nixVersions.latest;

  imports = lib.flatten [
    (map configLib.relativeToRoot [
      #################### Required Configs ####################
      "hosts/common/core"
    ])
  ];

}
