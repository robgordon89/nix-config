{ lib, flake-parts-lib, config, inputs, ... }:
{
  options = {
    configurations.darwin = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            default = "aarch64-darwin";
          };
          module = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
          };
        };
      });
      default = { };
    };

    flake = flake-parts-lib.mkSubmoduleOptions {
      darwinConfigurations = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.raw;
        default = { };
      };
    };
  };

  config.flake.darwinConfigurations = lib.mapAttrs (_: cfg:
    inputs.nix-darwin.lib.darwinSystem {
      inherit (cfg) system;
      modules = [ cfg.module ];
    }
  ) config.configurations.darwin;
}
