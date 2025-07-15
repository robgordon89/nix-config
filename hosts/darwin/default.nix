{ inputs
, outputs
, lib
, config
, pkgs
, hostConfig
, ...
}:
{
  imports = [
    ../../modules/darwin/default.nix
  ];

  # Set the State Version
  system.stateVersion = 5;

  # Set primary user from hostConfig
  system.primaryUser = hostConfig.username;

  environment.variables = {
    LANG = "en_GB.UTF-8";
  };

  time.timeZone = lib.mkDefault "Europe/London";

  # Nix configuration managed by determinate systems
  nix = {
    enable = false;
    package = pkgs.nix;
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
    hostPlatform = hostConfig.platform;
  };
}
