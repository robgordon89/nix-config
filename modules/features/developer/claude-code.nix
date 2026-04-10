{ ... }:
{
  flake.modules.homeManager.claudeCode = { pkgs, ... }:
    let
      statuslineScript = ''
        #!/bin/sh
        input=$(cat)

        cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
        model=$(echo "$input" | jq -r '.model.display_name // empty')
        remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

        # Shorten home directory to ~
        home="$HOME"
        short_cwd="''${cwd/#$home/~}"

        # Git branch (skip optional locks)
        branch=""
        if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
          branch=$(git -C "$cwd" -c core.fsync=none symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
        fi

        # Build output
        out=""

        # Directory
        if [ -n "$short_cwd" ]; then
          out="$short_cwd"
        fi

        # Git branch
        if [ -n "$branch" ]; then
          out="$out  $branch"
        fi

        # Model
        if [ -n "$model" ]; then
          out="$out  $model"
        fi

        # Context remaining
        if [ -n "$remaining" ]; then
          out="$out  ctx:$(printf '%.0f' "$remaining")%"
        fi

        printf '%s' "$out"
      '';

      settings = {
        env = {
          CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
          ANTHROPIC_MODEL = "opus";
          ANTHROPIC_SMALL_FAST_MODEL = "sonnet";
          ANTHROPIC_DEFAULT_HAIKU_MODEL = "haiku";
          CLAUDE_CODE_EFFORT_LEVEL = "max";
        };
        statusLine = {
          type = "command";
          command = "sh ~/.claude/statusline.sh";
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
    in
    {
      # Create symlink for claude in ~/.local/bin for shortcuts support
      home.file.".local/bin/claude" = {
        source = "${pkgs.claude-code}/bin/claude";
      };

      # Claude Code settings
      home.file.".claude/settings.json".text = builtins.toJSON settings;

      # Statusline script
      home.file.".claude/statusline.sh" = {
        text = statuslineScript;
        executable = true;
      };
    };
}
