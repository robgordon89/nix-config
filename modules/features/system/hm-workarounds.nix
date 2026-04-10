{ ... }:
{
  flake.modules.homeManager.hmWorkarounds = { ... }: {
    # Workaround: home-manager passes string instead of list to pathsToLink
    # https://github.com/nix-community/home-manager/issues/8163
    targets.darwin.linkApps.enable = false;
    home.file."Library/Fonts/.home-manager-fonts-version".enable = false;

    # Workaround: marked broken Oct 2022, revisit periodically
    # https://github.com/nix-community/home-manager/issues/3344
    manual.manpages.enable = false;

    # Skip manpage cache generation to speed up builds
    programs.man.generateCaches = false;
  };
}
