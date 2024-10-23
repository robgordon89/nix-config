{
  description = "Bob's Nix configuration";

  inputs = {
    #################### Official NixOS and HM Package Sources ####################
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # The next two are for pinning to stable vs unstable regardless of what the above is set to
    # See also 'stable-packages' and 'unstable-packages' overlays at 'overlays/default.nix"
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

    # MailerLite Defaults
    mailerlite = {
      # url = "git+file:///Users/robert/dev/mailerlite/nix-config";
      url = "git+ssh://git@github.com/mailerlite/nix-config.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
      ];
      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs inputs;
      };
      overlays = import ./overlays { inherit inputs; };
    in
    {
      overlays = import ./overlays { inherit inputs outputs; };

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
        titan = mkSystem "titan" {
          system = "aarch64-darwin";
          user = "robert";
          darwin = true;
          overlays = overlays;
          extraModules = [
            mailerlite.darwinModules."aarch64-darwin".sre
          ];
        };
        thebe = mkSystem "thebe" {
          system = "aarch64-darwin";
          user = "robert";
          darwin = true;
          overlays = overlays;
          extraModules = [
            mailerlite.darwinModules."aarch64-darwin".sre
          ];
        };
      };
    };
}
