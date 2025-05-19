{
  description = "Bob's Nix configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # VS Code Extensions
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
    };

    # Nix Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    # Homebrew Core
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    # Homebrew Cask
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # Pre-commit hooks
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # MailerLite shared flake - temp until upstreamed
    mailerlite = {
      url = "path:/Users/robert/dev/mailerlite/mailerlite-nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , home-manager
    , nix-homebrew
    , mailerlite
    , ...
    }@inputs:

    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;

      #
      # ========= Architectures =========
      #
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      #
      # ========= Overlays =========
      #
      # Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs; };

      #
      # ========= Host Configurations =========
      #
      # Building configurations is available through `just rebuild`.
      darwinConfigurations = {
        titan = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            overlays = [
              self.overlays.default
            ];
            config.allowUnfree = true;
          };
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            ./hosts/darwin
            mailerlite.darwinModules.home-manager
            {
              mailerlite.username = "robert";
              # mailerlite.useDefaultPackages = true;
              # mailerlite.useDefaultHomebrewPackages = false;
              mailerlite.useDefaultSSHConfig = true;
            }
          ];
          specialArgs = { inherit inputs; };
        };

        thebe = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            overlays = [ self.overlays.default ];
            config.allowUnfree = true;
          };
          modules = [
            inputs.vscodes.modules.default
            home-manager.darwinModules.home-manager
            ./hosts/darwin
          ];
          specialArgs = { inherit inputs; };
        };
      };

      #
      # ========= Packages =========
      #
      # Add custom packages to be shared or upstreamed.
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        lib.packagesFromDirectoryRecursive {
          callPackage = lib.callPackageWith pkgs;
          directory = ./pkgs/common;
        }
      );

      #
      # ========= Formatting =========
      #
      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      # Pre-commit checks
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks { inherit inputs system pkgs; }
      );
      #
      # ========= DevShell =========
      #
      # Custom shell for bootstrapping on new hosts, modifying nix-config, and secrets management
      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        }
      );
    };
}
