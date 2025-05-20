# mkHost.nix
# Helper to generate darwinConfigurations for each host

{ self, inputs }:
name: { extraConfig, extraModules }:
let
  system = "aarch64-darwin";
  overlays = [ self.overlays.default ];
  hostConfig = { hostname = name; } // extraConfig;
  pkgs = import inputs.nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    ./../../hosts/darwin
  ] ++ extraModules;
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system pkgs modules;
  specialArgs = { inherit inputs hostConfig; };
}
