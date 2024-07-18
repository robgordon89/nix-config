{ config, pkgs, ... }:

{
  # System level
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixVersions.latest;
  nix.settings.experimental-features = "nix-command flakes";

  imports = [
    ../modules/shared/cachix.nix
    ../modules/shared/systemPackages.nix
  ];

}
