{ inputs, ... }:
{
  flake.modules.darwin.homeManager = { config, pkgs, ... }: {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    users.users.${config.meta.username} = {
      home = "/Users/${config.meta.username}";
      shell = pkgs.zsh;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };

    home-manager.users.${config.meta.username} = {
      programs.home-manager.enable = true;
      home.stateVersion = "25.05";
      home.enableNixpkgsReleaseCheck = false;
    };
  };
}
