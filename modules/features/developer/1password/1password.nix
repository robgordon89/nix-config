{ ... }:
{
  flake.modules.darwin.onePassword = { config, ... }: {
    homebrew.casks = [{ name = "1password"; greedy = true; }];

    launchd.user.agents."com.1password.SSH_AUTH_SOCK" = {
      serviceConfig = {
        Label = "com.1password.SSH_AUTH_SOCK";
        ProgramArguments = [
          "/bin/sh"
          "-c"
          "/bin/ln -sf /Users/${config.meta.username}/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $SSH_AUTH_SOCK"
        ];
        RunAtLoad = true;
      };
    };
  };

  flake.modules.homeManager.onePassword = { ... }: {
    home.file.".config/1Password/ssh/agent.toml" = {
      source = ./_1password-agent.toml;
      recursive = true;
    };
  };
}
