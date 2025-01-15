{ ... }:

{
  # Set some user preferences
  system.defaults.CustomUserPreferences = {
    # Avoid creating .DS_Store files on network or USB volumes
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    "com.apple.frameworks.diskimages" = {
      skip-verify = true;
      skip-verify-locked = true;
      skip-verify-remote = true;
    };
  };

}
