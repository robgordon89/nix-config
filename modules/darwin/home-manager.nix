{ pkgs, inputs, hostConfig, ... }:
{
  users.users.${hostConfig.username} = {
    home = "/Users/${hostConfig.username}";
    shell = pkgs.zsh;
  };
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    users.${hostConfig.username} =
      { pkgs, ... }:
      {
        imports = [
          ./programs/1password-agent
          ./programs/brave
          ./programs/hammerspoon
          ./programs/wezterm
          ./programs/vscode
          ./programs/cursor
        ] ++ [ ../shared/home.nix ];

        _module.args = { inherit hostConfig; };

        programs.man.generateCaches = false;
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix { inherit hostConfig; };
          stateVersion = "25.05";
        };

        # Workaround: home-manager passes string instead of list to pathsToLink
        # This broke when nixpkgs started enforcing the list type strictly
        # https://github.com/nix-community/home-manager/issues/8163
        targets.darwin.linkApps.enable = false;

        # Disable the broken darwin fonts module (same pathsToLink bug)
        home.file."Library/Fonts/.home-manager-fonts-version".enable = false;

        # Marked broken Oct 20, 2022 check later to remove this
        # https://github.com/nix-community/home-manager/issues/3344
        manual.manpages.enable = false;
      };
  };
}
