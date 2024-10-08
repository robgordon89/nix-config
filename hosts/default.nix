{ config, pkgs, isDarwin, ... }:

{
  # System level
  services.nix-daemon.enable = true;
  system.stateVersion = 5;
  nix.package = pkgs.nixVersions.latest;

  imports = [
    ../modules/shared/systemPackages.nix
  ];

}
