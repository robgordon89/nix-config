# You can build these directly using 'nix build .#example'

{ pkgs ? import <nixpkgs> { }
,
}:
rec {
  #################### Packages with external source ####################
  zsh-term-title = pkgs.callPackage ./zsh-term-title { };
}
