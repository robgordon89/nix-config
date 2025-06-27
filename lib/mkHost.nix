# Helper to generate darwinConfigurations for each host
{ self, inputs }: name: { extraConfig, extraModules }:
let
  system = "aarch64-darwin";
  overlays = self.overlays;
  hostConfig = { hostname = name; } // extraConfig;
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
        user = extraConfig.username or "robert";
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
