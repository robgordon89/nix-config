{ ... }:
{
  flake.modules.homeManager.claudeCode =
    { pkgs, ... }:
    let
      settings = {
        prefersReducedMotion = true;
        feedbackSurveyRate = 0;
        spinnerTipsEnabled = false;
        env = {
          ANTHROPIC_MODEL = "opus";
          CLAUDE_CODE_EFFORT_LEVEL = "high";
        };
        # Read-only commands only. Anything that mutates state (git push, kubectl
        # apply/delete, tofu apply, rm, docker run) deliberately still prompts.
        permissions = {
          allow = [
            # shell / text
            "Bash(ls:*)"
            "Bash(cat:*)"
            "Bash(head:*)"
            "Bash(tail:*)"
            "Bash(grep:*)"
            "Bash(rg:*)"
            "Bash(find:*)"
            "Bash(fd:*)"
            "Bash(wc:*)"
            "Bash(sort:*)"
            "Bash(uniq:*)"
            "Bash(cut:*)"
            "Bash(tr:*)"
            "Bash(jq:*)"
            "Bash(yq:*)"
            "Bash(diff:*)"
            "Bash(file:*)"
            "Bash(stat:*)"
            "Bash(which:*)"
            "Bash(pwd)"
            "Bash(date:*)"
            "Bash(du:*)"
            "Bash(base64:*)"

            # git — read-only
            "Bash(git status:*)"
            "Bash(git log:*)"
            "Bash(git diff:*)"
            "Bash(git show:*)"
            "Bash(git branch:*)"
            "Bash(git remote -v)"
            "Bash(git rev-parse:*)"
            "Bash(git ls-files:*)"
            "Bash(git symbolic-ref:*)"
            "Bash(git fetch:*)"
            "Bash(git blame:*)"
            "Bash(git stash list)"
            "Bash(git worktree list)"

            # gh — read-only subcommands (gh api omitted: it can POST)
            "Bash(gh pr view:*)"
            "Bash(gh pr list:*)"
            "Bash(gh pr diff:*)"
            "Bash(gh pr checks:*)"
            "Bash(gh pr status:*)"
            "Bash(gh issue view:*)"
            "Bash(gh issue list:*)"
            "Bash(gh run view:*)"
            "Bash(gh run list:*)"
            "Bash(gh repo view:*)"
            "Bash(gh search:*)"
            "Bash(gh auth status)"

            # kubernetes — read-only verbs
            "Bash(kubectl get:*)"
            "Bash(kubectl describe:*)"
            "Bash(kubectl logs:*)"
            "Bash(kubectl top:*)"
            "Bash(kubectl explain:*)"
            "Bash(kubectl api-resources:*)"
            "Bash(kubectl config get-contexts:*)"
            "Bash(kubectl config current-context)"
            "Bash(flux get:*)"
            "Bash(helm list:*)"
            "Bash(helm template:*)"

            # terraform / opentofu — plan & inspect, never apply
            "Bash(tofu plan:*)"
            "Bash(tofu validate:*)"
            "Bash(tofu show:*)"
            "Bash(tofu fmt:*)"
            "Bash(tofu state list:*)"
            "Bash(tofu state show:*)"
            "Bash(terraform plan:*)"
            "Bash(terraform validate:*)"
            "Bash(terraform show:*)"
            "Bash(terraform fmt:*)"
            "Bash(terraform state list:*)"
            "Bash(terraform state show:*)"

            # build / test / lint
            "Bash(just --list)"
            "Bash(go test:*)"
            "Bash(go build:*)"
            "Bash(go vet:*)"
            "Bash(gofmt:*)"
            "Bash(golangci-lint:*)"
            "Bash(nix develop:*)"
            "Bash(nix flake check:*)"
            "Bash(nix flake metadata:*)"
            "Bash(nix fmt:*)"
            "Bash(nixfmt:*)"

            "WebSearch"
          ];
          deny = [
            # secrets never enter context — varlock/1Password are the source
            "Read(**/.env)"
            "Read(**/.env.*)"
            "Read(**/*.pem)"
            "Read(**/*.key)"
            "Read(**/id_rsa*)"
            "Read(**/.aws/credentials)"
          ];
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
