{ ... }:
{
  # Allow nix-darwin to overwrite the default macOS /etc/zshenv file
  environment.etc.knownSha256Hashes = [
    "67a980f208e0af83355b6c0d3ad36df6fae684fb593e5e76ebf7dfca83e90878" # macOS Sequoia default /etc/zshenv
  ];

  system = {
    defaults = {
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
        Bluetooth = true;
      };

      screencapture = {
        location = "~/Desktop";
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

    # Disable the startup chime
    startup.chime = false;

    # Enable key mapping
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
