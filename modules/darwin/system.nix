{ ... }:
{
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
