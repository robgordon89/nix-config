{ ... }:
{
  flake.modules.darwin.hammerspoon = {
    homebrew.casks = [ { name = "hammerspoon"; greedy = true; } ];
  };

  flake.modules.homeManager.hammerspoon = { ... }: {
    home.file.".hammerspoon" = {
      source = ./_config;
      recursive = true;
    };
  };
}
