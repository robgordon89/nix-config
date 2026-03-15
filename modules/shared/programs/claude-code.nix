{ pkgs, lib, hostConfig, ... }:

let
  cfg = hostConfig.claudeCode or { };
  useVertex = cfg.useVertex or false;

  baseSettings = {
    env = {
      CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      ANTHROPIC_MODEL = "opus";
      ANTHROPIC_SMALL_FAST_MODEL = "sonnet";
      ANTHROPIC_DEFAULT_HAIKU_MODEL = "haiku";
      CLAUDE_CODE_EFFORT_LEVEL = "max";
    };
    enabledPlugins = {
      "sre-standards@mailerlite-plugins" = true;
      "example-skills@anthropic-agent-skills" = true;
      "deep-project@piercelamb-plugins" = true;
      "deep-plan@piercelamb-plugins" = true;
      "deep-implement@piercelamb-plugins" = true;
      "dev-browser@dev-browser-marketplace" = true;
      "spec-interviewer@nkl-plugins" = true;
      "worktrunk@worktrunk" = true;
    };
    extraKnownMarketplaces = {
      "anthropic-agent-skills" = {
        source = {
          source = "github";
          repo = "anthropics/skills";
        };
      };
      "mailerlite-plugins" = {
        source = {
          source = "github";
          repo = "mailerlite/claude-marketplace";
        };
      };
      "nkl-plugins" = {
        source = {
          source = "github";
          repo = "nklmilojevic/claude-marketplace";
        };
      };
      "dev-browser-marketplace" = {
        source = {
          source = "github";
          repo = "sawyerhood/dev-browser";
        };
      };
      "piercelamb-plugins" = {
        source = {
          source = "github";
          repo = "piercelamb/deep-project";
        };
      };
      "worktrunk" = {
        source = {
          source = "github";
          repo = "max-sixty/worktrunk";
        };
      };
    };
  };

  vertexSettings = {
    env = {
      CLAUDE_CODE_USE_VERTEX = "1";
      CLOUD_ML_REGION = "global";
      ANTHROPIC_VERTEX_PROJECT_ID = cfg.vertexProjectId;
      ANTHROPIC_MODEL = "claude-opus-4-6@default";
      ANTHROPIC_SMALL_FAST_MODEL = "claude-sonnet-4-6@default";
      ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5@20251001";
    };
  };

  settings = baseSettings // (lib.optionalAttrs useVertex {
    env = baseSettings.env // vertexSettings.env;
  });
in
{
  # Create symlink for claude in ~/.local/bin for shortcuts support
  home.file.".local/bin/claude" = {
    source = "${pkgs.claude-code}/bin/claude";
  };

  # Claude Code settings
  home.file.".claude/settings.json".text = builtins.toJSON settings;
}
