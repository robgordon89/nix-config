{ ... }:
{
  flake.modules.darwin.homebrew = { config, ... }: {
    homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";
      onActivation.upgrade = true;
      global.autoUpdate = true;
      taps = builtins.attrNames config.nix-homebrew.taps;
    };
  };
}
