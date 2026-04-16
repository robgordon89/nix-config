{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
  meta = {
    work = {
      enable = true;
      team = "sre";
    };
    dockPathOverrides = {
      "/Applications/Beeper Desktop.app/" = "/Applications/Slack.app/";
    };
  };
in
{
  configurations.darwin.titan.module = {
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
