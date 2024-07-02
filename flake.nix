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
      hostName = "Bobs-MacBook-Air";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in
    {
      darwinConfigurations = {
        ${hostName} = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit system; };
          system = "${system}";
          modules = [
            home-manager.darwinModules.home-manager
            sre.darwinModules.${system}.defaults
            ./hosts/darwin
          ];
        };
      };
      darwinPackages = self.darwinConfigurations.${hostName}.pkgs;
    };
}
