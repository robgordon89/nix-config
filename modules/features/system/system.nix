{ lib, ... }:
{
  flake.modules.darwin.system = { config, ... }: {
    # Allow nix-darwin to overwrite the default macOS /etc/zshenv file
    environment.etc."zshenv".knownSha256Hashes = [
      "4e8f7cb9b699511f4ba5f9d5f8de1c9f5efb5c607de88faf5f58b8b9cb38edbf" # macOS default /etc/zshenv
    ];

    environment.variables.LANG = "en_GB.UTF-8";
    time.timeZone = lib.mkDefault "Europe/London";

    # Nix configuration managed by nix-darwin, compatible with Determinate Nix.
    # experimental-features must be set explicitly here since nix-darwin rewrites
    # /etc/nix/nix.conf and would otherwise drop Determinate's settings.
    nix.enable = true;
    nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];

    system.primaryUser = config.meta.username;

    system = {
      stateVersion = 6;
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

    # Merged from documentation.nix
    documentation = {
      enable = false;
      doc.enable = false;
      info.enable = false;
      man.enable = false;
    };
  };
}
