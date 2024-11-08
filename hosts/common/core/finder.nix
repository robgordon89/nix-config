{ config
, pkgs
, lib
, ...
}:

{
  # Set some sane defaults
  system.defaults = {
    # Set some finder defaults
    finder = {
      ShowPathbar = false;
      FXEnableExtensionChangeWarning = false;
      ShowStatusBar = false;
    };
  };
}
