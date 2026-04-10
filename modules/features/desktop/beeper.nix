{ ... }:
{
  flake.modules.darwin.beeper = {
    homebrew.casks = [ { name = "beeper"; greedy = true; } ];
  };
}
