{ config, currentSystemUser, lib, pkgs, ... }:

{
  users.users.${currentSystemUser} = {
    home = "/Users/${currentSystemUser}";
  };

  imports = [
    ../../modules/darwin/finder.nix
    ../../modules/darwin/security.nix
    ../../modules/darwin/launchAgents.nix
  ];

  # Set some user preferences
  system.defaults.CustomUserPreferences = {
    # Dont create .DS_Store files on network and USB volumes
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
