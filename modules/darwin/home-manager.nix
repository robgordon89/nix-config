{ config, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    users.${config.user} = { pkgs, config, lib, ... }: { };
  };
}
