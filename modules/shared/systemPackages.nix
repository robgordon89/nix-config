{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Custom Packages
    restic

    # Nix Tools and Utilities
    statix
    devenv
    nixpkgs-fmt
    pkgs.stable.kcl-cli
  ];
}
