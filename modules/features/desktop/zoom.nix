{ ... }:
{
  flake.modules.darwin.zoom = {
    homebrew.casks = [ { name = "zoom"; greedy = true; } ];
  };
}
