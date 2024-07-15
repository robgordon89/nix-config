{ config, currentSystemUser, lib, pkgs, ... }:

{
  users.users.${currentSystemUser} = {
    home = "/Users/${currentSystemUser}";
  };

  imports = [
    ../../modules/darwin/preferences.nix
    ../../modules/darwin/finder.nix
    ../../modules/darwin/security.nix
    ../../modules/darwin/launchAgents.nix
    ../../modules/darwin/home-manager.nix
  ];
}
