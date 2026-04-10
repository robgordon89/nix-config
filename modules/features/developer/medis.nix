{ ... }:
{
  flake.modules.darwin.medis = {
    homebrew.casks = [ { name = "medis"; greedy = true; } ];
  };
}
