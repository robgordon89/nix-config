# Helper to generate darwinConfigurations for each host
{ self, inputs }: name: { extraConfig, extraModules }:
let
  # Define the host configuration with default values, which can be overridden
  # by the extraConfig argument.
  hostConfig = {
    hostname = name;
    username = "robert";
    platform = "aarch64-darwin";
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
  ] ++ extraModules;
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system pkgs modules;
  specialArgs = { inherit inputs hostConfig; };
}
