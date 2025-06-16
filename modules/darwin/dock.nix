{ lib, hostConfig, ... }:

let
  defaultApps = [
    { name = "browser"; path = "/Applications/Brave Browser.app/"; }
    { name = "editor"; path = "/Applications/Visual Studio Code.app/"; }
    { name = "terminal"; path = "/Applications/WezTerm.app/"; }
    { name = "messaging"; path = "/Applications/Beeper Desktop.app/"; }
    { name = "passwordManager"; path = "/Applications/1Password.app/"; }
    { name = "databaseTool"; path = "/Applications/TablePlus.app/"; }
    { name = "settings"; path = "/System/Applications/System Settings.app/"; }
  ];

  getAppPath = app: hostConfig.dockAppOverrides.${app.name} or app.path;

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
    persistent-apps = map (app: getAppPath app) defaultApps;
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
