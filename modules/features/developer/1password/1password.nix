{ ... }:
{
  flake.modules.darwin.onePassword = { ... }: {
    homebrew.casks = [{ name = "1password"; greedy = true; }];
  };

  flake.modules.homeManager.onePassword = { config, ... }: {
    home.file.".config/1Password/ssh/agent.toml" = {
      source = ./_1password-agent.toml;
      recursive = true;
    };

    launchd.agents."com.1password.SSH_AUTH_SOCK" = {
      enable = true;
      config = {
        Label = "com.1password.SSH_AUTH_SOCK";
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "/bin/ln -sf ${config.home.homeDirectory}/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $SSH_AUTH_SOCK"
        ];
        RunAtLoad = true;
      };
    };
  };
}
