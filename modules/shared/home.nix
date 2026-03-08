{ pkgs, hostConfig ? { }, ... }:
{
  imports = [
    ./programs/claude-code
    ./programs/git
    ./programs/neovim
    ./programs/zsh
    ./programs/direnv.nix
    ./programs/fd.nix
    ./programs/gh.nix
    ./programs/k9s.nix
    ./programs/ssh.nix
    ./programs/zoxide.nix
    ./programs/kubernetes
    ./programs/python
    ./programs/ai-tools
    ./programs/node
    ./programs/php
  ];

  # Enable new tool modules with defaults
  programs.kubernetes = {
    enable = true;
    tools = {
      skaffold = true;
      kubebuilder = true;
      cilium = true;
    };
  };

  programs.pythonEnv = {
    enable = true;
    tools = {
      ansible = true;
      llm = {
        enable = true;
        plugins = with pkgs.python313.pkgs; [
          llm-ollama
          pkgs.llm-openrouter
        ];
      };
    };
    extraLibs = with pkgs.python313.pkgs; [
      git-filter-repo
    ];
  };

  programs.aiTools.enable = true;

  programs.nodeEnv = {
    enable = true;
    bun = true;
  };

  programs.phpEnv.enable = true;

  # Claude Code with full module configuration
  programs.claudeCode = {
    enable = true;
    experimental.agentTeams = true;

    plugins.enabled = {
      "deep-project@piercelamb-plugins" = true;
      "deep-plan@piercelamb-plugins" = true;
      "deep-implement@piercelamb-plugins" = true;
      "dev-browser@dev-browser-marketplace" = true;
      "spec-interviewer@nkl-plugins" = true;
    };

    plugins.marketplaces = {
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
    };
  };
}
