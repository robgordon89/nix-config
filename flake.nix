{
  description = "Bob's Nix configuration";

  inputs = {
    # Nix packages
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    # Nix Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SRE Defaults
    sre = {
      url = "git+ssh://git@github.com/mailergroup/nix-config.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, sre, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      darwinConfigurations = {
        Bobs-MacBook-Air = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit system; };
          modules = [
            home-manager.darwinModules.home-manager
            sre.darwinModules.${system}.defaults
            ./hosts/darwin
          ];
        };
      };
    };
}
