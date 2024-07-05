{ config, pkgs, lib, home-manager, ... }:

{
  options =
    {
      user.enable = lib.mkEnableOption {
        type = lib.types.bool;
        default = true;
        description = "Enable the user configuration";
      };
      user.name = lib.mkOption {
        type = lib.types.str;
        description = "The user's name";
      };
    };

  config = {
    # Disable man pages
    documentation.man.enable = false;

    # Set some sane defaults
    system.defaults = {
      # Set some finder defaults
      finder = {
        ShowPathbar = false;
        FXEnableExtensionChangeWarning = false;
        ShowStatusBar = false;
      };
    };

    environment.userLaunchAgents = {
      "com.1password.SSH_AUTH_SOCK.plist" = {
        source = pkgs.writeText "com.1password.SSH_AUTH_SOCK.plist" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"\>
          <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>com.1password.SSH_AUTH_SOCK</string>
            <key>ProgramArguments</key>
            <array>
              <string>/bin/sh</string>
              <string>-c</string>
              <string>/bin/ln -sf /Users/${config.user.name}/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $SSH_AUTH_SOCK</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
          </dict>
          </plist>
        '';
      };
    };

    # Set some user preferences
    system.defaults.CustomUserPreferences = {
      # Dont create .DS_Store files on network and USB volumes
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };

    # Allow the user to use sudo with Touch ID
    security.pam.enableSudoTouchIdAuth = true;
  };
}
