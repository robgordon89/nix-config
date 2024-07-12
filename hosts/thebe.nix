{ config, pkgs, ... }:

{
  # System level
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  imports = [
    ../modules/shared/systemPackages.nix
  ];

}
