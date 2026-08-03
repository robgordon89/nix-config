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
          "spec-interviewer@nkl-plugins" = true;
          "query@victoriametrics-tools" = true;
          "diagnostics@victoriametrics-tools" = true;
          "code-review@claude-plugins-official" = true;
        };
        extraKnownMarketplaces = {
          "claude-plugins-official" = {
            source = {
              source = "github";
              repo = "anthropics/claude-plugins-official";
            };
          };
          "nkl-plugins" = {
            source = {
              source = "github";
              repo = "nklmilojevic/claude-marketplace";
            };
          };
          "victoriametrics-tools" = {
            source = {
              source = "github";
              repo = "victoriametrics/skills";
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
