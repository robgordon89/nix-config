{
  description = "Nix configuration for Bobs-MacBook-Air";

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

    # SRE Defaults
    sre = {
      url = "git+ssh://git@github.com/mailergroup/nix-config.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sre, nix-darwin, ... }:
    let
       system = "aarch64-darwin";
       hostName = "Bobs-MacBook-Air";
       pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      darwinConfigurations = {
        ${hostName} = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit system; };
          system = "${system}";
          modules = [
            sre.darwinModules.${system}.defaults
        ];
        };
      };
      darwinPackages = self.darwinConfigurations.${hostName}.pkgs;
    };
}
