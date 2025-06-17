{ mailerlite, ... }:
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
    extraConfig = { };
    extraModules = [ ];
  };
}
