{ mailerlite, ... }:
{
  titan = {
    extraConfig = {
      dockAppOverrides = {
        # Use Cursor and Slack at work
        editor = "/Applications/Cursor.app/";
        messaging = "/Applications/Slack.app/";
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
