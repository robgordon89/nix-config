{ ... }:
let
  commitCommand = "CLAUDECODE= MAX_THINKING_TOKENS=0 claude -p --model=claude-haiku-4-5 --tools='' --disable-slash-commands --setting-sources='' --system-prompt=''";
in
{
  programs.worktrunk = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."worktrunk/config.toml".text = ''
    [commit.generation]
    command = "${commitCommand}"
  '';
}
