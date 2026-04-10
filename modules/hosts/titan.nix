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
      darwin.slack          # titan-only feature (cask: slack)
      darwin.zoom           # titan-only feature (cask: zoom)
      darwin.mailerlite     # titan-only feature (work)
    ];
    inherit meta;

    home-manager.sharedModules = [
      homeManager.mailerlite
      { inherit meta; }
    ];
  };
}
