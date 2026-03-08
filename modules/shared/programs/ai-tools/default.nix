{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.programs.aiTools;
in
{
  options.programs.aiTools = {
    enable = mkEnableOption "AI coding assistant tools";

    claudeCode = mkOption {
      type = types.bool;
      default = true;
      description = "Install Claude Code CLI.";
    };

    cursorCli = mkOption {
      type = types.bool;
      default = true;
      description = "Install Cursor CLI.";
    };

    codex = mkOption {
      type = types.bool;
      default = true;
      description = "Install OpenAI Codex CLI.";
    };

    geminiCli = mkOption {
      type = types.bool;
      default = true;
      description = "Install Gemini CLI.";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra AI tool packages to install.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      (lib.optional cfg.claudeCode claude-code)
      ++ (lib.optional cfg.cursorCli cursor-cli)
      ++ (lib.optional cfg.codex codex)
      ++ (lib.optional cfg.geminiCli gemini-cli)
      ++ cfg.extraPackages;
  };
}
