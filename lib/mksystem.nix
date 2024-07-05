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
  # userHMConfig = ../users/${user}/home-manager.nix;

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc rec {
  inherit system;

  modules = [
    hostConfig
    userOSConfig
    # home-manager.home-manager
    # {
    #   home-manager.useGlobalPkgs = true;
    #   home-manager.useUserPackages = true;
    #   home-manager.users.${user} = import userHMConfig {
    #     inputs = inputs;
    #   };
    # }

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
