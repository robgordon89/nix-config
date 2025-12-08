# Helper to generate darwinConfigurations for each host
{ self, inputs }: hostname: { extraConfig, extraDarwinModules ? [ ], extraHomeManagerModules ? [ ] }:
let
  # Define the host configuration with default values, which can be overridden
  # by the extraConfig argument.
  hostConfig = {
    hostname = hostname;
    username = "robert";
    firstName = "Robert";
    lastName = "Gordon";
    fullName = "${hostConfig.firstName} ${hostConfig.lastName}";
    email = "rob@ruled.io";
    sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJOD+xGS8a9Q2Dyyah+jH6caM2n4XaJNKRvmbo7NqaY";
    platform = "aarch64-darwin";
    extraHomeManagerPackages = [ ];
  } // extraConfig;

  system = hostConfig.platform;
  overlays = self.overlays;
  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config = {
      allowUnfree = true;
    };
  };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        sharedModules = extraHomeManagerModules;
      };
    }
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = hostConfig.username;
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
        mutableTaps = true;
      };
    }
    ./../hosts/darwin
  ] ++ extraDarwinModules;
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system pkgs modules;
  specialArgs = { inherit inputs hostConfig; };
}
