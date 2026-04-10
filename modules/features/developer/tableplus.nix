{ ... }:
{
  flake.modules.darwin.tableplus = {
    homebrew.casks = [ { name = "tableplus"; greedy = true; } ];
  };
}
