{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Custom Packages
    restic

    # Nix Tools and Utilities
    statix
    ansible-lint
    devenv
    nixpkgs-fmt
    pkgs.stable.kcl-cli
  ];
}
