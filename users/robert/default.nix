{
  config,
  configVars,
  lib,
  pkgs,
  ...
}:

{
  users.users.${configVars.username} = {
    home = "/Users/${configVars.username}";
    shell = pkgs.zsh;
  };

  environment.pathsToLink = [ "/share/zsh" ];
}
