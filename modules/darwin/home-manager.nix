{ config, pkgs, lib, home-manager, ... }:

let
  user = "robert";
in
{
     # Disable man pages
     documentation.man.enable = false;

     # Set some snae defaults
     system.defaults = {

        # Set some finder defaults
        finder = {
            ShowPathbar = true;
            FXEnableExtensionChangeWarning = false;
            ShowStatusBar = false;
        };
     };
    
    # Allow the user to use sudo with Touch ID
    security.pam.enableSudoTouchIdAuth = true;
}
