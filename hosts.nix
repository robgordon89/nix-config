{ mailerlite, lib, ... }:
{
  titan = {
    extraConfig = {
      dockPathOverrides = {
        # Use Slack at work
        "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/";
      };
      extraHomeManagerPackages = [ ]
        ++ mailerlite.pkgs.aarch64-darwin.sre;
      claudeCode = {
        useVertex = false;
        vertexProjectId = "mailerlite-claude-code";
      };
    };
    extraDarwinModules = [
      mailerlite.modules.darwin.defaults
      {
        mailerlite = {
          team = "sre";
        };
      }
    ];
    extraHomeManagerModules = [
      mailerlite.modules.home-manager.defaults
      {
        mailerlite =
          {
            team = "sre";
            # Disable modules that I don't use
            direnv.enable = false; # I use my own module
            ssh = {
              username = "robert";
            };
          };
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
        extraConfig = ''
          Host hack
            HostName fdaa:0:e692:0:1::2
        '';
      };
    };
    extraDarwinModules = [ ];
    extraHomeManagerModules = [ ];
  };
  ManagedsVirtualMachine = {
    extraConfig = {
      username = "admin";
      dockPathOverrides = {
        # Use Slack at work
        "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/";
      };
      extraHomeManagerPackages = [ ]
        ++ mailerlite.pkgs.aarch64-darwin.sre;
    };
    extraDarwinModules = [
      mailerlite.modules.darwin.defaults
      {
        mailerlite = {
          team = "sre";
        };
      }
    ];
    extraHomeManagerModules = [
      mailerlite.modules.home-manager.defaults
      {
        mailerlite =
          {
            team = "sre";
            # Disable modules that I don't use
            direnv.enable = false; # I use my own module
            ssh = {
              username = "admin";
            };
          };
      }
    ];
  };
}
