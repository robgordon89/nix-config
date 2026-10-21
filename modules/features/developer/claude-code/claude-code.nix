{ ... }:
{
  flake.modules.homeManager.claudeCode =
    { pkgs, lib, ... }:
    let
      thurmHook = event: [
        {
          hooks = [
            {
              type = "command";
              command = ''[ -n "$THURM_PANE_ID" ] && "''${THURM_BIN_DIR:+$THURM_BIN_DIR/}thurm" agent-hook claude ${event}; true'';
              timeout = 5;
            }
          ];
        }
      ];

      settings = {
        prefersReducedMotion = true;
        feedbackSurveyRate = 0;
        spinnerTipsEnabled = false;

        permissions = {
          allow = [
            "Read"
            "Grep"
            "Glob"
            "Bash(git status:*)"
            "Bash(git diff:*)"
            "Bash(git log:*)"
            "Bash(git show:*)"
            "Bash(git add:*)"
            "Bash(git commit:*)"
            "Bash(git push:*)"
            "Bash(gh pr view:*)"
            "Bash(gh pr diff:*)"
            "Bash(gh pr checks:*)"
            "Bash(gh pr create:*)"
            "Bash(gh run view:*)"
            "Bash(kubectl get:*)"
            "Bash(kubectl describe:*)"
            "Bash(kubectl logs:*)"
            "Bash(kubectl top:*)"
            "Bash(kubectl events:*)"
            "Bash(kubectl explain:*)"
            "Bash(kubectl api-resources:*)"
            "Bash(kubectl auth can-i:*)"
            "Bash(kubectl auth whoami:*)"
            "Bash(kubectl rollout status:*)"
            "Bash(kubectl rollout history:*)"
            "Bash(flux get:*)"
            "Bash(flux logs:*)"
            "Bash(flux events:*)"
            "Bash(flux tree:*)"
            "Bash(flux stats:*)"
            "Bash(flux diff kustomization:*)"
            "Bash(helm list:*)"
            "Bash(helm status:*)"
            "Bash(helm history:*)"
            "Bash(tofu plan:*)"
            "Bash(tofu validate:*)"
            "Bash(tofu show:*)"
            "Bash(tofu fmt:*)"
            "Bash(tofu state list:*)"
            "Bash(tofu state show:*)"
          ];
          ask = [
            "Bash(gh pr merge:*)"
          ];
          deny = [
            "Edit(**/.env*)"
            "Edit(**/*.pem)"
            "Edit(**/*.key)"
            "Edit(**/id_rsa*)"
            "Edit(**/id_ed25519*)"
            "Edit(**/.aws/credentials)"
            "Edit(**/kubeconfig)"
            "Edit(**/*service-account*.json)"
            "Bash(kubectl get secret:*)"
            "Bash(kubectl get secrets:*)"
            "Bash(git push --force:*)"
            "Bash(git push -f:*)"
          ];
        };
        hooks = lib.mapAttrs (_: thurmHook) {
          SessionStart = "session-start";
          UserPromptSubmit = "prompt-submit";
          Notification = "notification";
          PostToolUse = "tool-complete";
          Stop = "stop";
          SessionEnd = "session-end";
        };
        enabledPlugins = {
          "query@victoriametrics-tools" = true;
          "diagnostics@victoriametrics-tools" = true;
          "skills@robgordon89" = true;
        };
        extraKnownMarketplaces = {
          "victoriametrics-tools" = {
            source = {
              source = "github";
              repo = "victoriametrics/skills";
            };
          };
          "personal-skills" = {
            source = {
              source = "github";
              repo = "robgordon89/skills";
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

      # Global instructions loaded into every Claude Code session
      home.file.".claude/CLAUDE.md".source = ./_config/CLAUDE.md;
    };
}
