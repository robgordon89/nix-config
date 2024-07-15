{
  description = "Bob's Nix configuration";

  inputs = {
    # Nix packages
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    # Nix Stable packages
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
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
      inherit (self) outputs;
      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs inputs;
      };
      overlays = import ./overlays { inherit inputs; };
    in
    {
      overlays = import ./overlays { inherit inputs outputs; };
      darwinConfigurations."titan" = mkSystem "titan" {
        system = "aarch64-darwin";
        user = "robert";
        darwin = true;
        overlays = overlays;
        extraModules = [
          mailerlite.darwinModules."aarch64-darwin".sre
        ];
      };
      darwinConfigurations."thebe" = mkSystem "thebe" {
        system = "aarch64-darwin";
        user = "robert";
        darwin = true;
        overlays = overlays;
      };
    };
}
