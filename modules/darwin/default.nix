{ config, pkgs, lib, ... }:

{
  imports = [
    ./preferences.nix
    ./finder.nix
    ./security.nix
    ./launchAgents.nix
  ];
}
