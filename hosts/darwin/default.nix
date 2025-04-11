{ inputs
, outputs
, lib
, config
, pkgs
, ...
}:
{

  imports = [
    ../../modules/darwin/default.nix
  ];

  # Set the State Version
  system.stateVersion = 5;

  environment.variables = {
    LANG = "en_GB.UTF-8";
  };

  time.timeZone = lib.mkDefault "Europe/London";

  # Nix configuration managed by determinate systems
  nix = {
    enable = false;
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
}
