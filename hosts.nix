{ mailerlite, lib, ... }:
{
  titan = {
    extraConfig = {
      useCursor = true;
      dockPathOverrides = {
        # Use Cursor and Slack at work
        "/Applications/Visual Studio Code.app/" = "/Applications/Cursor.app/";
        "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/";
      };
    };
    extraDarwinModules = [
      mailerlite.modules.darwin.defaults
      {
        mailerlite = {
          onepasswordAgent.enable = false;
        };
      }
    ];
    extraHomeManagerModules = [
      mailerlite.modules.home-manager.defaults
      {
        mailerlite =
          {
            git.enable = false;
            ssh.enable = false;
            direnv.enable = false;
            shell.enable = false;
            notifier.enable = true;
            onepassword.enable = false;
          };
      }
    ];
  };
  thebe = {
    extraConfig = {
      useVscode = true;
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
    extraDarwinModules = [ ];
    extraHomeManagerModules = [ ];
  };
  test = {
    extraConfig = {
      useVscode = true;
    };
    extraDarwinModules = [ ];
    extraHomeManagerModules = [ ];
  };
}
