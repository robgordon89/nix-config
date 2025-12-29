{ mailerlite, lib, ... }:
let
  system = "aarch64-darwin";
in
{
  titan = {
    extraConfig = {
      useCursor = true;
      dockPathOverrides = {
        # Use Cursor and Slack at work
        "/Applications/Visual Studio Code.app/" = "/Applications/Cursor.app/";
        "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/";
      };
      extraHomeManagerPackages = [ ]
        ++ mailerlite.pkgs.${system}.sre;
    };
    extraDarwinModules = [
      mailerlite.modules.darwin.defaults
      {
        # mailerlite = { };
      }
    ];
    extraHomeManagerModules = [
      mailerlite.modules.home-manager.defaults
      {
        mailerlite =
          {
            # Disable modules that I don't use
            direnv.enable = false;
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
