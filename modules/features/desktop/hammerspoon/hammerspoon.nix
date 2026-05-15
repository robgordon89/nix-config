{ ... }:
{
  flake.modules.darwin.hammerspoon = {
    homebrew.casks = [ { name = "hammerspoon"; greedy = true; } ];
  };

  flake.modules.homeManager.hammerspoon =
    { config, lib, ... }:
    let
      cfg = config.meta.hammerspoon;
      # Each entry maps a meta flag to the module file under _config/modules.
      # Order matches the require order originally hard-coded in init.lua.
      candidates = [
        { flag = "caffeine"; name = "caffeine"; }
        { flag = "launcher"; name = "launcher"; }
        { flag = "windowmanager"; name = "windowmanager"; }
        { flag = "reloader"; name = "reloader"; }
        { flag = "githubNotifications"; name = "github-notifications"; }
        { flag = "githubPrs"; name = "github-prs"; }
        { flag = "linearNotifications"; name = "linear-notifications"; }
        { flag = "incidentIo"; name = "incident-io"; }
      ];
      enabled = lib.filter (m: cfg.${m.flag}) candidates;
      initLua = lib.concatMapStringsSep "\n" (m: ''require("modules/${m.name}")'') enabled + "\n";
    in
    {
      home.file.".hammerspoon/modules" = {
        source = ./_config/modules;
        recursive = true;
      };
      home.file.".hammerspoon/Spoons" = {
        source = ./_config/Spoons;
        recursive = true;
      };
      home.file.".hammerspoon/init.lua".text = initLua;
    };
}
