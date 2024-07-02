{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Custom Packages
    restic
    statix
    nixpkgs-fmt
  ];
}
