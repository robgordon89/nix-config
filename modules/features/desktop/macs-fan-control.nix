{ ... }:
{
  flake.modules.darwin.macs-fan-control = {
    homebrew.casks = [{ name = "macs-fan-control"; greedy = true; }];
  };
}
