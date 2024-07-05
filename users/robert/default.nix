{ config, currentSystemUser, lib, pkgs, ... }:

{
  imports = [
    ../../modules/darwin/finder.nix
    ../../modules/darwin/launchAgents.nix
  ];
  # Allow the user to use sudo with Touch ID
  security.pam.enableSudoTouchIdAuth = true;

  # Disable man pages
  documentation.man.enable = false;

  # Set some user preferences
  system.defaults.CustomUserPreferences = {
    # Dont create .DS_Store files on network and USB volumes
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
