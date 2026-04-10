{ inputs, ... }:
{
  flake.modules.darwin.nixHomebrew = { config, ... }: {
    imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
    nix-homebrew = {
      enable = true;
      user = config.meta.username;
      autoMigrate = true;
      mutableTaps = false;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
    };
  };
}
