{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.programs.nodeEnv;
in
{
  options.programs.nodeEnv = {
    enable = mkEnableOption "Node.js development environment";

    package = mkOption {
      type = types.package;
      default = pkgs.nodejs_22;
      description = "Node.js package to use.";
    };

    typescript = mkOption {
      type = types.bool;
      default = true;
      description = "Install TypeScript.";
    };

    yarn = mkOption {
      type = types.bool;
      default = true;
      description = "Install Yarn.";
    };

    bun = mkOption {
      type = types.bool;
      default = false;
      description = "Install Bun runtime.";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra Node.js related packages.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ cfg.package ]
      ++ (lib.optional cfg.typescript typescript)
      ++ (lib.optional cfg.yarn yarn)
      ++ (lib.optional cfg.bun bun)
      ++ cfg.extraPackages;
  };
}
