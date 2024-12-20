{ pkgs
, lib
, inputs
, outputs
, configLib
, configVars
, ...
}:
{
  imports = lib.flatten [
    (configLib.scanPaths ./.)
    inputs.home-manager.darwinModules.home-manager
    # (builtins.attrValues outputs.nix-darwin)
  ];
}
