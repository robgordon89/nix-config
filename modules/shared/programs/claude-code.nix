{ pkgs, lib, hostConfig, ... }:

let
  cfg = hostConfig.claudeCode or { };
  useVertex = cfg.useVertex or false;

  baseSettings = {
    enabledPlugins = { };
  };

  vertexSettings = {
    env = {
      CLAUDE_CODE_USE_VERTEX = "1";
      CLOUD_ML_REGION = "global";
      ANTHROPIC_VERTEX_PROJECT_ID = cfg.vertexProjectId;
      ANTHROPIC_MODEL = "claude-opus-4-6@default";
      ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5@20251001";
    };
  };

  settings = baseSettings // (lib.optionalAttrs useVertex vertexSettings);
in
{
  # Create symlink for claude in ~/.local/bin for shortcuts support
  home.file.".local/bin/claude" = {
    source = "${pkgs.claude-code}/bin/claude";
  };

  # Claude Code settings
  home.file.".claude/settings.json".text = builtins.toJSON settings;
}
