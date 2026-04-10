{ ... }:
{
  flake.modules.darwin.cloudflareWarp = {
    homebrew.casks = [ { name = "cloudflare-warp"; greedy = true; } ];
  };
}
