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

    # MailerLite Defaults
    mailerlite = {
      # url = "git+file:///Users/robert/dev/mailerlite/nix-config";
      url = "git+ssh://git@github.com/mailerlite/nix-config.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, mailerlite, ... }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs inputs;
      };
    in
    {
      darwinConfigurations."titan" = mkSystem "titan" {
        system = "aarch64-darwin";
        user = "robert";
        darwin = true;
        extraModules = [
          mailerlite.darwinModules."aarch64-darwin".sre
        ];
      };
    };
}
