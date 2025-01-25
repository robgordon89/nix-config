{ pkgs, ... }:
let
  user = "robert";
in
{
  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
  };

  documentation.man = {
    enable = false;
  };

  system.defaults = {

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits = "Centimeters";
      ApplePressAndHoldEnabled = true;
      AppleScrollerPagingBehavior = false;
      AppleShowAllExtensions = false;
      AppleShowAllFiles = false;
      AppleShowScrollBars = "WhenScrolling";
      AppleSpacesSwitchOnActivate = true;
      AppleTemperatureUnit = "Celsius";
      AppleWindowTabbingMode = "fullscreen";
      InitialKeyRepeat = 30;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = true;
      "com.apple.mouse.tapBehavior" = 1;
    };

    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true; # 18 on 24 off
    };

    loginwindow = {
      GuestEnabled = false;
    };

    trackpad = {
      Clicking = true;
      Dragging = false;
      TrackpadThreeFingerDrag = false;
    };
  };

  system.activationScripts.postUserActivation.text = ''
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    killall Dock
  '';

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  services.karabiner-elements = {
    enable = false;
    # Use stable see https://github.com/LnL7/nix-darwin/issues/1041
    package = pkgs.stable.karabiner-elements;
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, ... }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./programs/packages.nix { };
        stateVersion = "25.05";
      };

      imports = [
        ../shared/home-manager.nix
        ./programs/hammerspoon
        ./programs/karabiner
        ./programs/1password-agent
        ./programs/wezterm
        ./programs/vscode
      ];

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };
}
