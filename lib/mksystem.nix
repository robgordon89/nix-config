# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, inputs }:

name:
{ system
, user
, darwin ? false
, extraModules ? [ ]
}:

let
  # The config files for this system.
  hostConfig = ../hosts/${name}.nix;
  userOSConfig = ../users/${user};
  userHomeConfig = ../users/${user}/home.nix;

  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
  };

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
  home-manager = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc rec {
  inherit system pkgs;

  modules = [
    hostConfig
    userOSConfig
    home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.users.${user} = import userHomeConfig {
        inputs = inputs;
        pkgs = pkgs;
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
      };
    }
  ] ++ extraModules;
}
