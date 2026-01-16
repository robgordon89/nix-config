{ lib, hostConfig, ... }:

let
  defaultApps = [
    { app = "/Applications/Brave Browser.app"; }
    { app = "/Applications/Visual Studio Code.app"; }
    { app = "/Applications/WezTerm.app"; }
    { app = "/Applications/Beeper Desktop.app"; }
    { app = "/Applications/1Password.app"; }
    { app = "/Applications/TablePlus.app"; }
    { app = "/System/Applications/System Settings.app"; }
  ];

  # Apply path overrides if specified
  applyPathOverrides = apps:
    let
      overrides = hostConfig.dockPathOverrides or { };
    in
    map
      (item:
        let
          path = item.app;
          newPath = overrides.${path + "/"} or overrides.${path} or path;
        in
        { app = newPath; }
      )
      apps;

  # Give default settings a low priority (50)
  defaultDock = lib.mapAttrs (name: value: lib.mkDefault value) {
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
      { folder = { path = "/Applications"; showas = "grid"; displayas = "folder"; }; }
      { folder = { path = "/Users/${hostConfig.username}/Downloads"; showas = "grid"; displayas = "folder"; }; }
    ];
  };

  # Apply a higher priority (80) to host-specific settings
  hostDock = lib.mapAttrs (name: value: lib.mkOverride 80 value) (hostConfig.dock or { });
in
{
  system.defaults.dock = lib.mkMerge [
    defaultDock
    hostDock
  ];
}
