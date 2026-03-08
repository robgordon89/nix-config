{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.programs.pythonEnv;

  pythonWithPackages = cfg.package.buildEnv.override {
    extraLibs = cfg.extraLibs;
    ignoreCollisions = true;
  };
in
{
  options.programs.pythonEnv = {
    enable = mkEnableOption "Python development environment";

    package = mkOption {
      type = types.package;
      default = pkgs.python313;
      description = "Python package to use.";
    };

    extraLibs = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra Python libraries to include in the environment.";
      example = lib.literalExpression ''
        with pkgs.python313.pkgs; [
          pyyaml
          ruff
        ]
      '';
    };

    tools = {
      ruff = mkOption {
        type = types.bool;
        default = true;
        description = "Include ruff linter.";
      };

      pyyaml = mkOption {
        type = types.bool;
        default = true;
        description = "Include PyYAML.";
      };

      ansible = mkOption {
        type = types.bool;
        default = false;
        description = "Include ansible-core.";
      };

      llm = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Include LLM CLI tools.";
        };

        plugins = mkOption {
          type = types.listOf types.package;
          default = [ ];
          description = "LLM plugins to include.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.pythonEnv.extraLibs = with cfg.package.pkgs;
      (lib.optional cfg.tools.ruff ruff)
      ++ (lib.optional cfg.tools.pyyaml pyyaml)
      ++ (lib.optional cfg.tools.ansible ansible-core)
      ++ (lib.optionals cfg.tools.llm.enable ([ llm llm-cmd ] ++ cfg.tools.llm.plugins));

    home.packages = [ pythonWithPackages ];
  };
}
