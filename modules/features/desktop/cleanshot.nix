{ ... }:
{
  flake.modules.darwin.cleanshot = {
    homebrew.casks = [ { name = "cleanshot"; greedy = true; } ];
  };
}
