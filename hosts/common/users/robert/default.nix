{ pkgs
, inputs
, config
, lib
, configVars
, configLib
, ...
}:
let
  fullUserConfig = {
    users.users.${configVars.username} = {
      packages = [ pkgs.home-manager ];
    };

    # Import this user's personal/home configurations
    home-manager.users.${configVars.username} = import (
      configLib.relativeToRoot "home/${configVars.username}/${config.networking.hostName}.nix"
    );
  };
in
{
  config =
    lib.recursiveUpdate fullUserConfig
      #this is the second argument to recursiveUpdate
      {
        users.users.${configVars.username} = {
          home = "/Users/${configVars.username}";
          shell = pkgs.zsh; # default shell
        };
      };
}
