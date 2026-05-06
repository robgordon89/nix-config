{ ... }:
{
  flake.modules.homeManager.claudeCode =
    { pkgs, ... }:
    let
      settings = {
        env = {
          CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
          ANTHROPIC_MODEL = "opus";
          ANTHROPIC_SMALL_FAST_MODEL = "sonnet";
          ANTHROPIC_DEFAULT_HAIKU_MODEL = "haiku";
          CLAUDE_CODE_EFFORT_LEVEL = "high";
        };
        enabledPlugins = {
          "example-skills@anthropic-agent-skills" = true;
          "deep-project@piercelamb-plugins" = true;
          "deep-plan@piercelamb-plugins" = true;
          "deep-implement@piercelamb-plugins" = true;
          "dev-browser@dev-browser-marketplace" = true;
          "spec-interviewer@nkl-plugins" = true;
          "worktrunk@worktrunk" = true;
        };
        extraKnownMarketplaces = {
          "claude-plugins-official" = {
            source = {
              source = "github";
              repo = "anthropics/claude-plugins-official";
            };
          };
          "anthropic-agent-skills" = {
            source = {
              source = "github";
              repo = "anthropics/skills";
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
    in
    {
      # Create symlink for claude in ~/.local/bin for shortcuts support
      home.file.".local/bin/claude" = {
        source = "${pkgs.claude-code}/bin/claude";
      };

      # Claude Code settings
      home.file.".claude/settings.json".text = builtins.toJSON settings;
    };
}
