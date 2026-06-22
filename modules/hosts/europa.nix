{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
  meta = {
    work = {
      enable = true;
      team = "sre";
    };
    dockPathOverrides = {
      "" = "/Applications/Slack.app/";
    };
    hammerspoon = {
      linearNotifications = true;
      incidentIo = true;
    };
  };
in
{
  configurations.darwin.europa.module = {
    imports = [
      darwin.base
      darwin.slack
      darwin.zoom
      darwin.mailerlite
    ];
    inherit meta;

    home-manager.sharedModules = [
      homeManager.mailerlite
      { inherit meta; }
    ];
  };
}
