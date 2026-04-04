{ pkgs, ... }:
{
  imports = [
    ./dock.nix
    ./documentation.nix
    ./finder.nix
    ./fonts.nix
    ./home-manager.nix
    ./homebrew.nix
    ./launchAgents.nix
    ./preferences.nix
    ./security.nix
    ./system.nix
    ./services.nix
  ];
}
