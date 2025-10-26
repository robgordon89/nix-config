{ config, hostConfig ? { }, ... }:
let
  mkGreedy = caskName: { name = caskName; greedy = true; };

  # Conditionally include editor casks based on host config
  editorCasks =
    (if hostConfig.useVscode or false then [ "visual-studio-code" ] else [ ]) ++
    (if hostConfig.useCursor or false then [ "cursor" ] else [ ]);
in
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
    global.autoUpdate = true;

    taps = builtins.attrNames config.nix-homebrew.taps;

    # casks = map mkGreedy [];
    casks = map mkGreedy [
      "1password"
      "wezterm"
      "brave-browser"
      "hammerspoon"
      "medis"
      "orbstack"
      "slack"
      "syntax-highlight"
      "tableplus"
      "zoom"
      "claude"
      "mouseless"
    ] ++ editorCasks;
  };
}
