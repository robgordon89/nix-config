{ mailerlite, lib, ... }:
{
  titan = {
    extraConfig = {
      dockPathOverrides = {
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
            direnv.enable = false;
            ssh = {
              username = "robert";
            };
          };
      }
    ];
  };
  thebe = { };
}
