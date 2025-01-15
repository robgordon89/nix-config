{ inputs
, pkgs
, ...
}: {
  imports = [
    ../../modules/darwin/finder.nix
    ../../modules/darwin/fonts.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/darwin/launchAgents.nix
    ../../modules/darwin/prefrences.nix
    ../../modules/darwin/security.nix
    ../../modules/shared/cachix.nix
  ];

  # Set the State Version
  system.stateVersion = 5;

  # Enable the Nix daemon
  services.nix-daemon.enable = true;

  environment.variables = {
    LANG = "en_GB.UTF-8";
  };

  time.timeZone = lib.mkDefault "Europe/London";

  # Nix configuration
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      trusted-users = [ "@wheel" ];
      warn-dirty = false;

      allow-import-from-derivation = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
    hostPlatform = "aarch64-darwin";
  };

  home-manager = {
    backupFileExtension = "backup";
    users.robert = {
      programs.man.generateCaches = false;
    };
  };
}
