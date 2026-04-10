{ inputs, ... }:
{
  flake.modules.darwin.overlays = {
    nixpkgs.overlays = builtins.attrValues (import ../overlays { inherit inputs; });
    nixpkgs.config.allowUnfree = true;
  };
}
