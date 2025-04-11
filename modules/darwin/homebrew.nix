{ config, ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;

    taps = [
      "robusta-dev/homebrew-krr"
    ];

    brews = [
      # temp nix build wont work on krr https://github.com/NixOS/nixpkgs/issues/327629
      "krr"
    ];

    casks = [
      "1password"
      "wezterm"
      "brave-browser"
      "hammerspoon"
      "karabiner-elements"
      "medis"
      "orbstack"
      "slack"
      "syntax-highlight"
      "tableplus"
      "visual-studio-code"
      "zoom"
    ];

    # masApps = {
    #   "1Password for Safari" = 1569813296;
    #   "AdGuard for Safari" = 1440147259;
    #   "Amphetamine" = 937984704;
    #   "Anybox" = 1593408455;
    #   "CARROT Weather" = 993487541;
    #   "Developer" = 640199958;
    #   "Home Assistant" = 1099568401;
    #   "Hover for Safari" = 1540705431;
    #   "iMovie" = 408981434;
    #   "Invoice Ninja" = 1503970375;
    #   "Kagi for Safari" = 1622835804;
    #   "Keka" = 470158793;
    #   "Keynote" = 409183694;
    #   "Logic Pro" = 634148309;
    #   "MQTT Explorer" = 1455214828;
    #   "NotePlan" = 1505432629;
    #   "Numbers" = 409203825;
    #   "NZBVortex 3" = 914250185;
    #   "Pages" = 409201541;
    #   "Parcel" = 639968404;
    #   "Pixelmator Pro" = 1289583905;
    #   "Sink It for Reddit" = 6449873635;
    #   "Soulver 3" = 1508732804;
    #   "SponsorBlock" = 1573461917;
    #   "StopTheMadness Pro" = 6471380298;
    #   "Tailscale" = 1475387142;
    #   "Telegram" = 747648890;
    #   "Things" = 904280696;
    #   "UnTrap" = 1637438059;
    #   "Wipr" = 1662217862;
    #   "WireGuard" = 1451685025;
    #   "Yubico Authenticator" = 1497506650;
    # };
  };
}
