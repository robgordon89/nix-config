{ ... }:
{
  flake.modules.homeManager.php = { config, lib, pkgs, ... }: {
    home.packages = [
      pkgs.php84
      pkgs.php84Packages.composer
      pkgs.php84Packages.php-cs-fixer
      pkgs.deployer
    ];

    home.sessionPath = [
      "${config.home.homeDirectory}/.config/composer/vendor/bin"
    ];
  };
}
