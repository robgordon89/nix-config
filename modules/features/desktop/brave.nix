{ ... }:
{
  flake.modules.darwin.brave = {
    homebrew.casks = [ { name = "brave-browser"; greedy = true; } ];
  };
}
