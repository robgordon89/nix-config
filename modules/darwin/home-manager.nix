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
            <string>/bin/ln -sf /Users/${user}/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $SSH_AUTH_SOCK</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
        </plist>
      '';
    };
  };


  # Allow the user to use sudo with Touch ID
  security.pam.enableSudoTouchIdAuth = true;
}
