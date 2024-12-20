{ config
, pkgs
, lib
, ...
}:

{
  # Set some user preferences
  system.defaults.CustomUserPreferences = {
    # Dont create .DS_Store files on network and USB volumes
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
