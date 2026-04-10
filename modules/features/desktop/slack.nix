{ ... }:
{
  flake.modules.darwin.slack = {
    homebrew.casks = [ { name = "slack"; greedy = true; } ];
  };
}
