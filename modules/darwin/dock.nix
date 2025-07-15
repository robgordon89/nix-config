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
      "/Applications"
      "/Users/robert/Downloads"
    ];
  };

  # Apply a higher priority (80) to host-specific settings
  hostDock =
    if (hostConfig ? dock)
    then lib.mapAttrs (name: value: lib.mkOverride 80 value) hostConfig.dock
    else { };
in
{
  system.defaults.dock = lib.mkMerge [
    defaultDock
    hostDock
  ];
}
