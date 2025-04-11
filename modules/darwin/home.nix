{ pkgs, ... }:
let
  user = "robert";
in
{
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };
  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    users.${user} =
      { pkgs, ... }:
      {
        programs.man.generateCaches = false;
        home = {
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix { };
          stateVersion = "25.05";
        };
        imports = [
          ./programs/1password-agent
          ./programs/brave
          ./programs/hammerspoon
          ./programs/karabiner
          ./programs/wezterm
          ./programs/vscode
        ] ++ [ ../shared/home.nix ];

        # Marked broken Oct 20, 2022 check later to remove this
        # https://github.com/nix-community/home-manager/issues/3344
        manual.manpages.enable = false;
      };
  };
}
