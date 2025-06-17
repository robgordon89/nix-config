{ lib, hostConfig, ... }:

let
  defaultApps = [
    "/Applications/Brave Browser.app/"
    "/Applications/Visual Studio Code.app/"
    "/Applications/WezTerm.app/"
    "/Applications/Beeper Desktop.app/"
    "/Applications/1Password.app/"
    "/Applications/TablePlus.app/"
    "/System/Applications/System Settings.app/"
  ];

  # Apply path overrides if specified
  applyPathOverrides = apps:
    let
      overrides = hostConfig.dockPathOverrides or { };
    in
    map (app: overrides.${app} or app) apps;

  defaultDock = {
    autohide = true;
    minimize-to-application = true;
    show-process-indicators = true;
    show-recents = false;
    static-only = false;
    showhidden = false;
    tilesize = 48;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
    persistent-apps = applyPathOverrides defaultApps;
    persistent-others = [
      "/Applications"
      "/Users/robert/Downloads"
    ];
  };
in
{
  system.defaults.dock = lib.mkMerge [
    defaultDock
    (hostConfig.dock or { })
  ];
}
