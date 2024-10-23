{
  description = "Bob's Nix configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    # MailerLite
    mailerlite = {
      # url = "git+file:///Users/robert/dev/mailerlite/nix-config";
      url = "git+ssh://git@github.com/mailerlite/nix-config.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-commit hooks
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      mailerlite,
      pre-commit-hooks,
      ...
    }@inputs:

    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
      ];

      overlays = import ./overlays { inherit inputs; };
      configLib = import ./lib {
        inherit
          inputs
          nixpkgs
          overlays
          lib
          ;
      };
    in
    {
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks { inherit inputs system pkgs; }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        in
        import ./shell.nix { inherit checks pkgs; }
      );

      darwinConfigurations = {
        titan = configLib.mkSystem {
          host = "titan";
          extraModules = [
            mailerlite.darwinModules."aarch64-darwin".sre
          ];
        };

        thebe = configLib.mkSystem {
          host = "thebe";
          extraModules = [
            mailerlite.darwinModules."aarch64-darwin".sre
          ];
        };
      };
    };
}
