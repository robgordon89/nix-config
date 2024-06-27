{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Custom Packages
    # bob
  ];

  # Enable the nix daemon
  services.nix-daemon.enable = true;

  # Enable not free packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features
  nix.settings.experimental-features = "nix-command flakes";

  # Set the host platform to aarch64-darwin
  nixpkgs.hostPlatform = "aarch64-darwin";
}
