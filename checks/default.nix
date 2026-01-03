{ inputs
, system
, ...
}:
{
  pre-commit-check = inputs.pre-commit-hooks.lib.${stdenv.hostPlatform.system}.run {
    src = ./.;
    default_stages = [ "pre-commit" ];
    hooks = {
      # ========== General ==========
      check-added-large-files.enable = true;
      check-case-conflicts.enable = true;
      check-executables-have-shebangs.enable = true;
      check-shebang-scripts-are-executable.enable = false; # many of the scripts in the config aren't executable because they don't need to be.
      check-merge-conflicts.enable = true;
      detect-private-keys.enable = true;
      fix-byte-order-marker.enable = true;
      mixed-line-endings.enable = true;
      trim-trailing-whitespace.enable = true;

      forbid-submodules = {
        enable = true;
        name = "forbid submodules";
        description = "forbids any submodules in the repository";
        language = "fail";
        entry = "submodules are not allowed in this repository:";
        types = [ "directory" ];
      };

      destroyed-symlinks = {
        enable = false;
      };

      # ========== nix ==========
      nixpkgs-fmt = {
        enable = true;
      };

      # ========== shellscripts ==========
      shfmt.enable = false;

      end-of-file-fixer.enable = true;
    };
  };
}
