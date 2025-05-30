{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    settings =
      {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    extensions = [ pkgs.gh-copilot ];
  };
}
