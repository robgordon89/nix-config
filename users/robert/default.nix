{ config, currentSystemUser, lib, pkgs, ... }:

{
  users.users.${currentSystemUser} = {
    home = "/Users/${currentSystemUser}";
    shell = pkgs.zsh;
  };

  environment.pathsToLink = [ "/share/zsh" ];
}
