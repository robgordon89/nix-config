{ ... }:
{
  flake.modules.darwin.onePassword = {
    homebrew.casks = [ { name = "1password"; greedy = true; } ];
  };

  flake.modules.homeManager.onePassword = { ... }: {
    home.file.".config/1Password/ssh/agent.toml" = {
      source = ./_1password-agent.toml;
      recursive = true;
    };
  };
}
