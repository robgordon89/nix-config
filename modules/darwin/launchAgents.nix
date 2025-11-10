{ pkgs, hostConfig, ... }:
{
  launchd.user.agents."com.1password.SSH_AUTH_SOCK" = {
    serviceConfig = {
      Label = "com.1password.SSH_AUTH_SOCK";
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/ln -sf /Users/${hostConfig.username}/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $SSH_AUTH_SOCK"
      ];
      RunAtLoad = true;
    };
  };
}
