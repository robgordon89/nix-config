{ config, currentSystemUser, lib, pkgs, ... }:

{
  users.users.${currentSystemUser} = {
    home = "/Users/${currentSystemUser}";
  };
}
