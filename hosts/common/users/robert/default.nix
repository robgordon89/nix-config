{
  pkgs,
  inputs,
  config,
  lib,
  configVars,
  configLib,
  ...
}:
let
  # these are values we don't want to set if the environment is minimal. E.g. ISO or nixos-installer
  # isMinimal is true in the nixos-installer/flake.nix
  fullUserConfig = lib.optionalAttrs (!configVars.isMinimal) {
    users.users.${configVars.username} = {
      hashedPasswordFile = sopsHashedPasswordFile;
      packages = [ pkgs.home-manager ];
    };

    # Import this user's personal/home configurations
    home-manager.users.${configVars.username} = import (
      configLib.relativeToRoot "home/${configVars.username}/${config.networking.hostName}.nix"
    );
  };
in
{
  users.users.${configVars.username} = {
    home = "/home/${configVars.username}";
    shell = pkgs.zsh; # default shell
  };
  # No matter what environment we are in we want these tools for root, and the user(s)
  programs.zsh.enable = true;
  programs.git.enable = true;
  environment.systemPackages = [
    pkgs.just
    pkgs.rsync
  ];
}
