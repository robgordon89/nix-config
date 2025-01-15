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
