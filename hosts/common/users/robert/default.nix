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

in
{
  # users.users.${configVars.username} = {
  #   home = "/home/${configVars.username}";
  #   shell = pkgs.zsh; # default shell
  # };
  # # No matter what environment we are in we want these tools for root, and the user(s)
  # programs.zsh.enable = true;
  # programs.git.enable = true;
  # environment.systemPackages = [
  #   pkgs.just
  #   pkgs.rsync
  # ];
}
