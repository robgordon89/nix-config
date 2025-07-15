{ config, ... }:
let
  mkGreedy = caskName: { name = caskName; greedy = true; };
in
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;

    taps = builtins.attrNames config.nix-homebrew.taps;

    # casks = map mkGreedy [];
    casks = [
      "1password"
      "wezterm"
      "brave-browser"
      "hammerspoon"
      "medis"
      "orbstack"
      "slack"
      "syntax-highlight"
      "tableplus"
      "visual-studio-code"
      "zoom"
      "cursor"
      "claude"
      "mouseless"
    ];
  };
}
