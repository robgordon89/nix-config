{ mailerlite, lib, ... }:
{
  titan = {
    extraConfig = {
      dockPathOverrides = {
        # Use Cursor and Slack at work
        "/Applications/Visual Studio Code.app/" = "/Applications/Cursor.app/";
        "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/";
      };
    };
    extraModules = [
      mailerlite.darwinModules.home-manager
      {
        mailerlite.username = "robert";
        mailerlite.useDefaultSSHConfig = true;
      }
    ];
  };
  thebe = {
    extraConfig = {
      dock = {
        # Slightly smaller icons on the dock (default is 48)
        tilesize = 42;
      };
      ssh = {
        enable = true;
        extraConfig = ''
          Host hack
            HostName fdaa:0:e692:0:1::2
        '';
      };
    };
    extraModules = [ ];
  };
}
