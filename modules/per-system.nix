{ inputs, ... }:
{
  perSystem = { pkgs, system, ... }: {
    formatter = pkgs.nixfmt;

    devShells.default = pkgs.mkShell {
      inherit (inputs.lefthook.lib.${system}.run {
        src = inputs.self;
        config.pre-commit.commands.nixfmt = {
          run = "${pkgs.lib.getExe pkgs.nixfmt} {staged_files}";
          glob = "*.nix";
        };
      }) shellHook;
      nativeBuildInputs = builtins.attrValues {
        inherit (pkgs) nixpkgs-fmt nil go-task nixfmt;
      };
    };

    checks.lefthook-check = inputs.lefthook.lib.${system}.run {
      src = inputs.self;
      config.pre-commit.commands.nixfmt = {
        run = "${pkgs.lib.getExe pkgs.nixfmt} {staged_files}";
        glob = "*.nix";
      };
    };
  };
}
