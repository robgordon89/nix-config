{ inputs, ... }:
final: _prev: {
  stable = import inputs.nixpkgs-stable {
    localSystem = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
}
