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
    (configLib.relativeToRoot "hosts/common/users/${configVars.username}")
  ];

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  services.nix-daemon.enable = true;

  nixpkgs = {
    # you can add global overlays here
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };
}
