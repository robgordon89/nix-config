{ pkgs
, lib
, inputs
, outputs
, configLib
, configVars
, ...
}:
let

  #FIXME:(configLib) switch this and other instances to configLib function
  homeDirectory =
    if pkgs.stdenv.isLinux then "/home/${configVars.username}" else "/Users/${configVars.username}";
in
{
  imports = lib.flatten [
    (configLib.scanPaths ./.)
    (configLib.relativeToRoot "hosts/common/users/${configVars.username}")
    inputs.home-manager.darwinModules.home-manager
    # (builtins.attrValues outputs.nix-darwin)
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
