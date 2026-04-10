{ config, ... }:
let
  mkGreedy = caskName: {
    name = caskName;
    greedy = true;
  };
in
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
    global.autoUpdate = true;

    taps = builtins.attrNames config.nix-homebrew.taps;

    casks = map mkGreedy [
      "1password"
      "ghostty"
      "brave-browser"
      "hammerspoon"
      "medis"
      "slack"
      "syntax-highlight"
      "tableplus"
      "zoom"
      "logi-options+"
      "visual-studio-code"
      "cleanshot"
      "swiftbar"
      "cloudflare-warp"
    ];
  };
}
