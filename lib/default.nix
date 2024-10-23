{
  inputs,
  nixpkgs,
  overlays,
  lib,
  ...
}:

let
  relativeToRoot = lib.path.append ../.;
in
{
  # Expose mkSystem and relativeToRoot for external use
  mkSystem =
    {
      system ? "aarch64-darwin",
      host,
      user ? "robert",
      darwin ? true,
      extraModules ? [ ],
    }:
    let
      # The config files for this system.
      defaultHostConfig = relativeToRoot "hosts/default.nix";
      hostConfig = relativeToRoot "hosts/${host}.nix";

      userConfig = relativeToRoot "users/${user}";
      userHomeConfig = relativeToRoot "users/${user}/home.nix";

      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config = {
          allowUnfree = true;
        };
      };

      # NixOS vs nix-darwin functions
      systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      home-manager =
        if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
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

        # Expose extra arguments for modules
        {
          config._module.args = {
            currentSystem = system;
            currentSystemName = host;
            currentSystemUser = user;
            inputs = inputs;
            isDarwin = darwin;
          };
        }
      ] ++ extraModules;
    };

  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );

  # Make relativeToRoot available for use in other modules
  inherit relativeToRoot;
}
