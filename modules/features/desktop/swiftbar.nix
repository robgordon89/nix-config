{ ... }:
{
  flake.modules.darwin.swiftbar = {
    homebrew.casks = [ { name = "swiftbar"; greedy = true; } ];
  };
}
