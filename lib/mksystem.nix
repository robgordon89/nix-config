# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, inputs }:

name:
{ system
, user
, darwin ? false
, overlays ? null
, extraModules ? [ ]
}:

let
  # The config files for this system.
  defaultHostConfig = ../hosts/default.nix;
  hostConfig = ../hosts/${name}.nix;

  userConfig = ../users/${user};
  userHomeConfig = ../users/${user}/home.nix;

  pkgs = import nixpkgs {
    inherit system;
    overlays = builtins.attrValues overlays;
    config = { allowUnfree = true; };
  };

  # NixOS vs nix-darwin functions
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
  home-manager = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc rec {
  inherit system pkgs;

  modules = [
    defaultHostConfig
    userConfig
    hostConfig
    home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.users.${user} = import userHomeConfig {
        inherit inputs pkgs;
      };
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        inputs = inputs;
        isDarwin = darwin;
      };
    }
  ]
  ++ extraModules;
}
