{ ... }:
{
  flake.modules.darwin.tailscale = {
    homebrew.casks = [{ name = "tailscale-app"; greedy = true; }];
  };
}
