{ ... }:
{
  flake.modules.darwin.logiOptions = {
    homebrew.casks = [ { name = "logi-options+"; greedy = true; } ];
  };
}
