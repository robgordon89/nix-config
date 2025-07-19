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

        programs.man.generateCaches = false;
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix { };
          stateVersion = "25.05";
        };

        # Marked broken Oct 20, 2022 check later to remove this
        # https://github.com/nix-community/home-manager/issues/3344
        manual.manpages.enable = false;
      };
  };
}
