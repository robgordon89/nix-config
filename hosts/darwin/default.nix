{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Custom Packages
    restic

    # Shell Tools
    eza
  ];
}
