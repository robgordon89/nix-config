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

  # Enable zsh at this stage to avoid the need to restart the shell
  programs.zsh.enable = true;

}
