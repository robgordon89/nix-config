{ pkgs, ... }:
{
  system.defaults = {
    # Set some finder defaults
    finder = {
      ShowPathbar = false;
      FXEnableExtensionChangeWarning = false;
      ShowStatusBar = false;
    };
  };
}
