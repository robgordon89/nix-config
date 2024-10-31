# You can build these directly using 'nix build .#example'

{
  pkgs ? import <nixpkgs> { },
}:
rec {
  zsh-term-title = pkgs.callPackage ./zsh-term-title { };
}
