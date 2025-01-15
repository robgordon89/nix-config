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
    # dock = {
    #   minimize-to-application = true;
    #   show-process-indicators = true;
    #   show-recents = false;
    #   static-only = false;
    #   showhidden = false;
    #   tilesize = 48;
    #   wvous-bl-corner = 1;
    #   wvous-br-corner = 1;
    #   wvous-tl-corner = 1;
    #   wvous-tr-corner = 1;
    #   persistent-apps = [
    #     "Applications/Finder.app"
    #     "/Applications/Brave Browser.app/"
    #     "/System/Applications/Mail.app/"
    #     "/System/Applications/Messages.app/"
    #     "/Applications/Slack.app/"
    #     "/Applications/Telegram.app"
    #     "/Applications/Ghostty.app/"
    #     "/Applications/Fantastical.app/"
    #     "/Applications/Discord.app/"
    #     "/Applications/Anybox.app/"
    #     "/Applications/Things3.app/"
    #     "/Applications/NotePlan.app/"
    #     "/Applications/Spotify.app/"
    #     "/Applications/RapidAPI.app/"
    #     "/Applications/TablePlus.app/"
    #     "/Applications/Linear.app/"
    #   ];
    # };

    # finder = {
    #   ShowPathbar = true;
    #   FXEnableExtensionChangeWarning = false;
    #   ShowStatusBar = true;
    # };

    # NSGlobalDomain = {
    #   AppleKeyboardUIMode = 3;
    #   AppleMeasurementUnits = "Centimeters";
    #   InitialKeyRepeat = 30;
    #   KeyRepeat = 1;
    #   "com.apple.keyboard.fnState" = true;
    #   AppleShowScrollBars = "WhenScrolling";
    # };

    # loginwindow = {
    #   GuestEnabled = false;
    # };

    # menuExtraClock = {
    #   Show24Hour = true;
    # };

    # trackpad = {
    #   Clicking = true;
    #   Dragging = false;
    #   TrackpadThreeFingerDrag = false;
    # };
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
        # ./programs/karabiner
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
