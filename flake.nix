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
      platform = "aarch64-darwin";
      hostName = "Bobs-MacBook-Air";
      isWork = if (nixpkgs.lib.strings.toLower hostName == "bobs-macbook-air") then true else false;
      pkgs = import nixpkgs {
        inherit platform;
      };
    in
    {
      darwinConfigurations = {
        ${hostName} = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit platform isWork; };
          modules = [
            home-manager.darwinModules.home-manager
            sre.darwinModules.${platform}.defaults
            ./hosts
          ];
        };
      };
    };
}
