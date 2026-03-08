{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge mkDefault mkOverride types;
  cfg = config.programs.claudeCode;

  # Build the final settings.json from all module options
  mergedSettings = {
    env = cfg.env;
  }
  // (if cfg.plugins.enabled != { } then { enabledPlugins = cfg.plugins.enabled; } else { })
  // (if cfg.plugins.marketplaces != { } then { extraKnownMarketplaces = cfg.plugins.marketplaces; } else { });

  # Generate skill file content from a skill attrset
  mkSkillContent = name: skill:
    let
      header = lib.optionalString (skill.description != "") "# ${skill.description}\n\n";
      trigger = lib.optionalString (skill.trigger != "") "**Trigger:** ${skill.trigger}\n\n";
      tools = lib.optionalString (skill.tools != [ ])
        "**Tools:** ${lib.concatStringsSep ", " skill.tools}\n\n";
      invocable = lib.optionalString skill.userInvocable
        "**User invocable:** Yes (/${name})\n\n";
    in
    header + trigger + tools + invocable + skill.instructions;

in
{
  options.programs.claudeCode = {
    enable = mkEnableOption "Claude Code AI assistant";

    package = mkOption {
      type = types.package;
      default = pkgs.claude-code;
      description = "The Claude Code package to use.";
    };

    # Environment variables
    env = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Environment variables for Claude Code settings.";
      example = {
        ANTHROPIC_MODEL = "opus";
        ANTHROPIC_SMALL_FAST_MODEL = "sonnet";
      };
    };

    # Model configuration (convenience options that set env vars)
    models = {
      primary = mkOption {
        type = types.str;
        default = "opus";
        description = "Primary model alias or full model ID.";
      };

      fast = mkOption {
        type = types.str;
        default = "sonnet";
        description = "Fast model alias or full model ID.";
      };

      haiku = mkOption {
        type = types.str;
        default = "haiku";
        description = "Haiku model alias or full model ID.";
      };
    };

    # Vertex AI configuration
    vertex = {
      enable = mkEnableOption "Google Vertex AI backend";

      projectId = mkOption {
        type = types.str;
        default = "";
        description = "Google Cloud project ID for Vertex AI.";
      };

      region = mkOption {
        type = types.str;
        default = "global";
        description = "Google Cloud region for Vertex AI.";
      };

      models = {
        primary = mkOption {
          type = types.str;
          default = "claude-opus-4-6@default";
          description = "Primary model ID for Vertex AI.";
        };

        fast = mkOption {
          type = types.str;
          default = "claude-sonnet-4-6@default";
          description = "Fast model ID for Vertex AI.";
        };

        haiku = mkOption {
          type = types.str;
          default = "claude-haiku-4-5@20251001";
          description = "Haiku model ID for Vertex AI.";
        };
      };
    };

    # Experimental features
    experimental = {
      agentTeams = mkEnableOption "experimental agent teams feature";
    };

    # Plugin system
    plugins = {
      enabled = mkOption {
        type = types.attrsOf types.bool;
        default = { };
        description = "Map of plugin identifiers to enabled state.";
        example = {
          "deep-project@piercelamb-plugins" = true;
          "dev-browser@dev-browser-marketplace" = true;
        };
      };

      marketplaces = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            source = mkOption {
              type = types.submodule {
                options = {
                  source = mkOption {
                    type = types.enum [ "github" "gitlab" "url" ];
                    default = "github";
                    description = "Source type for the marketplace.";
                  };
                  repo = mkOption {
                    type = types.str;
                    description = "Repository path (e.g., 'owner/repo').";
                  };
                };
              };
              description = "Source configuration for this marketplace.";
            };
          };
        });
        default = { };
        description = "Custom plugin marketplaces.";
      };
    };

    # Skills configuration - generates ~/.claude/skills/*.md files
    skills = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          description = mkOption {
            type = types.str;
            default = "";
            description = "Human-readable description of the skill.";
          };

          trigger = mkOption {
            type = types.str;
            default = "";
            description = "When this skill should be triggered.";
          };

          instructions = mkOption {
            type = types.lines;
            default = "";
            description = "The skill instructions/prompt content.";
          };

          tools = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of tools this skill has access to.";
          };

          userInvocable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the user can invoke this skill directly via slash command.";
          };
        };
      });
      default = { };
      description = ''
        Claude Code skills configuration. Each skill generates a markdown
        file in ~/.claude/skills/ that Claude Code can discover and use.
      '';
      example = {
        "nix-build" = {
          description = "Build and test nix configuration";
          trigger = "When user asks to build or test nix config";
          instructions = "Run task build to build the nix configuration.";
          userInvocable = true;
        };
      };
    };

    # Create symlink in ~/.local/bin
    createBinSymlink = mkOption {
      type = types.bool;
      default = true;
      description = "Create a symlink at ~/.local/bin/claude.";
    };

    # Extra raw settings to merge into settings.json
    extraSettings = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra raw settings to merge into settings.json.";
    };
  };

  config = mkIf cfg.enable {
    # Build environment variables from convenience options
    programs.claudeCode.env = mkMerge [
      # Model configuration (default priority so vertex can override)
      {
        ANTHROPIC_MODEL = mkDefault cfg.models.primary;
        ANTHROPIC_SMALL_FAST_MODEL = mkDefault cfg.models.fast;
        ANTHROPIC_DEFAULT_HAIKU_MODEL = mkDefault cfg.models.haiku;
      }

      # Experimental features
      (mkIf cfg.experimental.agentTeams {
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      })

      # Vertex AI (higher priority overrides model defaults)
      (mkIf cfg.vertex.enable {
        CLAUDE_CODE_USE_VERTEX = "1";
        CLOUD_ML_REGION = cfg.vertex.region;
        ANTHROPIC_VERTEX_PROJECT_ID = cfg.vertex.projectId;
        ANTHROPIC_MODEL = mkOverride 80 cfg.vertex.models.primary;
        ANTHROPIC_SMALL_FAST_MODEL = mkOverride 80 cfg.vertex.models.fast;
        ANTHROPIC_DEFAULT_HAIKU_MODEL = mkOverride 80 cfg.vertex.models.haiku;
      })
    ];

    # Generate home files
    home.file = mkMerge [
      # Symlink for shortcuts support
      (mkIf cfg.createBinSymlink {
        ".local/bin/claude".source = "${cfg.package}/bin/claude";
      })

      # Settings file
      {
        ".claude/settings.json".text = builtins.toJSON (mergedSettings // cfg.extraSettings);
      }

      # Skill files - each skill becomes a markdown file in ~/.claude/skills/
      (lib.mapAttrs'
        (name: skill: lib.nameValuePair
          ".claude/skills/${name}.md"
          { text = mkSkillContent name skill; }
        )
        cfg.skills
      )
    ];
  };
}
