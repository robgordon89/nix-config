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

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
      ];

      inherit (nixpkgs) lib;

      configVars = import ../vars { inherit inputs lib; };
      configLib = import ./lib { inherit lib; };

      overlays = import ./overlays { inherit inputs; };

      specialArgs = {
        inherit
          inputs
          outputs
          configVars
          configLib
          nixpkgs
          ;
      };
    in
    {
      # Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs outputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks { inherit inputs system pkgs; }
      );

      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        in
        import ./shell.nix { inherit checks pkgs; }
      );

      darwinConfigurations = {
        titan = nix-darwin.lib.darwinSystem {
          inherit specialArgs;
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/titan
            mailerlite.darwinModules."aarch64-darwin".sre
          ];
        };
        # titan = configLib.mkSystem {
        #   host = "titan";
        #   specialArgs = {
        #     isWork = false;
        #   };
        #   extraModules = [
        #     mailerlite.darwinModules."aarch64-darwin".sre
        #   ];
        # };

        # thebe = configLib.mkSystem {
        #   host = "thebe";
        #   extraModules = [
        #     mailerlite.darwinModules."aarch64-darwin".sre
        #   ];
        # };
      };
    };
}
